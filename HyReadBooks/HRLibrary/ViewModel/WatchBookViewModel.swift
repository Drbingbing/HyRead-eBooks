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
                    .map { cacheSavedBook(book: book, shouldSave: $0) }
            }
        
        let book = Observable.merge(configuredBook, saveBookToggle)
        
        saveButtonSelected = book.map(\.1)
            .asDriver(onErrorJustReturn: false)
    }
    
    // MARK: - Outpus
    public let saveButtonSelected: Driver<Bool>
    
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
