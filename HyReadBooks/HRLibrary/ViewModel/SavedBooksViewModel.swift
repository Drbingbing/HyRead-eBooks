//
//  SavedBooksViewModel.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/19.
//

import Foundation
import HRApi
import RxSwift
import RxCocoa
import HRLocalStorage

public protocol SavedBooksViewModelOutputs {
    var books: Driver<[Book]> { get }
}

public protocol SavedBooksViewModelInputs {
    func viewWillAppear()
    
    /// Call when save button tapped.
    func setNeesdReload()
}

public protocol SavedBooksViewModelProtocol {
    var inputs: SavedBooksViewModelInputs { get }
    var outputs: SavedBooksViewModelOutputs { get }
}

public final class SavedBooksViewModel: SavedBooksViewModelProtocol, SavedBooksViewModelInputs, SavedBooksViewModelOutputs {
    
    public init() {
        
        let collections = AppEnvironment.current.localStorage.fetchMyBooks()
            .map { $0.map(asBook) }
        
        let savedBookIDs = AppEnvironment.current.localStorage.fetchCollections()
            .map { $0.map { Int($0.uuid) } }
        
        let configureBooks = Signal.zip(savedBookIDs, collections)
            .map(searchSavedBooks)
        
        let reloadTrigger = Observable.merge(viewWillAppearSubject, setNeedReloadSubject)
        
        books = reloadTrigger.flatMap { configureBooks }
            .asDriver(onErrorJustReturn: [])
    }
    
    public var inputs: SavedBooksViewModelInputs { return self }
    public var outputs: SavedBooksViewModelOutputs { return self }
    
    // MARK: - Outputs
    public let books: Driver<[Book]>
    
    // MARK: - Inputs
    private let viewWillAppearSubject = PublishSubject<Void>()
    public func viewWillAppear() {
        viewWillAppearSubject.onNext(())
    }
    
    private let setNeedReloadSubject = PublishSubject<Void>()
    public func setNeesdReload() {
        setNeedReloadSubject.onNext(())
    }
}

private func searchSavedBooks(by ids: [Int], books: [Book]) -> [Book] {
    return books.filter { ids.contains($0.uuid) }
}
