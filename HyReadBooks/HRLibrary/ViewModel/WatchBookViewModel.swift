//
//  WatchBookViewModel.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import HRApi
import RxCocoa
import RxSwift

public protocol WatchBookViewModelInputs {
    
    /// Call to configure with saved property.
    func configure(book: Book)
    func saveButtonTapped(selected: Bool)
}

public protocol WatchBookViewModelOutputs {
    
    /// Emits when the project has been successfully saved and a prompt should be shown to the user.
    var saveButtonSelected: Driver<Bool> { get }
    
    /// Emits when haptic feedback should be generated
    var generateImpactFeedback: Driver<Void> { get }
    
    /// Emits the hint for the save button.
    var saveButtonSelectedHint: Driver<String> { get }
    
    /// Emit the delegate for the save button tapped.
    var saveButtonDelegate: Observable<(book: Book, isSaved: Bool)> { get }
}

public protocol WatchBookViewModelProtocol {
    
    var inputs: WatchBookViewModelInputs { get }
    var outputs: WatchBookViewModelOutputs { get }
}

public final class WatchBookViewModel: WatchBookViewModelProtocol, WatchBookViewModelInputs, WatchBookViewModelOutputs {
    
    public var outputs: WatchBookViewModelOutputs { return self }
    public var inputs: WatchBookViewModelInputs { return self }
    
    public init() {
        
        let saveButtonTrigger = saveButtonSubject
        let configuredBook = configureSubject
            .map(isBookSaved)
        
        let bookOnSaveButtonToggle = configuredBook
            .map(\.0)
            .flatMap { book in
                saveButtonTrigger.map { (book, $0) }
            }
        
        /// make the mutation request to the save/unsave.
        /// update the cache with the result and return it
        let saveBookToggle = bookOnSaveButtonToggle
            .map { book, selected in (book, !selected) }
            .flatMap { book, shouldSave in
                saveBookProducer(with: book, shouldSave: shouldSave)
                    .map { _ in cacheSavedBook(book: book, shouldSave: shouldSave) }
            }
        
        let book = Observable.merge(configuredBook, saveBookToggle)
        
        saveButtonSelected = book.map(\.1)
            .asDriver(onErrorJustReturn: false)
        
        saveButtonDelegate = saveBookToggle.map { (book: $0, isSaved: $1) }
        
        generateImpactFeedback = saveBookToggle
            .map { _ in Void() }
            .asDriver(onErrorJustReturn: ())
        
        saveButtonSelectedHint = saveBookToggle
            .map(\.1)
            .map { $0 ? "✅ 成功加入收藏" : "✅ 已從收藏移除" }
            .asDriver(onErrorJustReturn: "")
    }
    
    // MARK: - Outpus
    public let saveButtonSelected: Driver<Bool>
    public let generateImpactFeedback: Driver<Void>
    public let saveButtonSelectedHint: Driver<String>
    public let saveButtonDelegate: Observable<(book: Book, isSaved: Bool)>
    
    // MARK: - Inputs
    private let configureSubject = PublishSubject<Book>()
    public func configure(book: Book) {
        configureSubject.onNext(book)
    }
    
    private let saveButtonSubject = PublishSubject<Bool>()
    public func saveButtonTapped(selected: Bool) {
        saveButtonSubject.onNext(selected)
    }
}

private func saveBookProducer(
  with book: Book,
  shouldSave: Bool
) -> Signal<Bool> {
    guard shouldSave else {
        return AppEnvironment.current.localStorage.removeFromCollections(book)
    }
    
    return AppEnvironment.current.localStorage.addToCollections(book)
}

private func isBookSaved(_ book: Book) -> (Book, Bool) {
    guard let cache = AppEnvironment.current.cache[HRCache.hr_bookSaved] as? [Int: Bool] else {
      return (book, false)
    }
    
    return (book, cache[book.uuid] ?? false)
}

private func cacheSavedBook(book: Book, shouldSave: Bool) -> (Book, Bool) {
    // create cache if it doesn't exist yet
    let tryCache = AppEnvironment.current.cache[HRCache.hr_bookSaved]
    AppEnvironment.current.cache[HRCache.hr_bookSaved] = tryCache ?? [Int: Bool]()
    
    // prepare result
    guard var cache = AppEnvironment.current.cache[HRCache.hr_bookSaved] as? [Int: Bool] else {
      return (book, shouldSave)
    }
    
    // write to cache
    cache[book.uuid] = shouldSave
    AppEnvironment.current.cache[HRCache.hr_bookSaved] = cache
    
    return (book, shouldSave)
}
