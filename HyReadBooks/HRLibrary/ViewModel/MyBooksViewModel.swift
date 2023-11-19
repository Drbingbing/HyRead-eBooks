//
//  MyBooksViewModel.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import HRApi
import RxCocoa
import RxSwift
import HRLocalStorage

public protocol MyBooksViewModelInputs {
    
    /// Call from the controller's `viewDidLoad` method.
    func viewDidLoad()
    
    func saveBook(_ book: Book, shouldSave: Bool)
    
    func layoutButtonTapped()
    func tapped(selectableRow: BookLayoutTemplateSeletableRow)
}

public protocol MyBooksViewModelOutputs {
    
    /// Emits the array of books that should be set on collectionview.
    var books: Driver<[Book]> { get }
    
    var goToLayoutTemplate: Observable<BookLayoutTemplateSeletableRow> { get }
    
    var preferredColumns: Driver<Int> { get }
}

public protocol MyBooksViewModelProtocol {
    
    var inputs: MyBooksViewModelInputs { get }
    var outputs: MyBooksViewModelOutputs { get }
}


public final class MyBooksViewModel: MyBooksViewModelProtocol, MyBooksViewModelInputs, MyBooksViewModelOutputs {
    
    public init() {
        let store = AppEnvironment.current.localStorage.fetchMyBooks()
            .asObservable()
            .map { $0.map(asBook) }
            .catchAndReturn([])
        let remote = AppEnvironment.current.apiService.userList()
            .asObservable()
            .map { try $0.get() }
            .flatMap { books in
                AppEnvironment.current.localStorage.saveMyBooks(books)
                    .map { _ in books }
            }
            .catchAndReturn([])
        
        let savedBooks = AppEnvironment.current.localStorage.fetchCollections()
            .asObservable()
            .map { $0.map { Int($0.uuid) } }
        
        books = viewDidLoadSubject
            .flatMap { Observable.merge(store, remote) }
            .withLatestFrom(savedBooks) { cacheSavedBooks($1, books: $0) }
            .asDriver(onErrorJustReturn: [])
        
        goToLayoutTemplate = layoutButtonSubject
            .map {
                AppEnvironment.current.keyValueStore.prefferredColumns
            }
            .map { BookLayoutTemplateSeletableRow(params: $0, isSelected: true) }
            .asObservable()
        
        let configureLayout = Observable.merge(fetchPrefferedColumns(), selectableRowSubject)
        
        preferredColumns = configureLayout.map(cacheSavedLayout)
            .map(\.params)
            .asDriver(onErrorJustReturn: 3)
    }
    
    public var inputs: MyBooksViewModelInputs { return self }
    public var outputs: MyBooksViewModelOutputs { return self }
    
    // MARK: - Outputs
    public let books: Driver<[Book]>
    public let goToLayoutTemplate: Observable<BookLayoutTemplateSeletableRow>
    public let preferredColumns: Driver<Int>
    
    // MARK: - Inputs
    private let viewDidLoadSubject = PublishSubject<Void>()
    public func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
    
    private let saveBookSubject = PublishSubject<(book: Book, shouldSave: Bool)>()
    public func saveBook(_ book: Book, shouldSave: Bool) {
        saveBookSubject.onNext((book, shouldSave))
    }
    
    private let layoutButtonSubject = PublishSubject<Void>()
    public func layoutButtonTapped() {
        layoutButtonSubject.onNext(())
    }
    
    private let selectableRowSubject = PublishSubject<BookLayoutTemplateSeletableRow>()
    public func tapped(selectableRow: BookLayoutTemplateSeletableRow) {
        selectableRowSubject.onNext(selectableRow)
    }
}

private func cacheSavedBooks(_ booksSaved: [Int], books: [Book]) -> [Book] {
    // create cache if it doesn't exist yet
    let tryCache = AppEnvironment.current.cache[HRCache.hr_bookSaved]
    AppEnvironment.current.cache[HRCache.hr_bookSaved] = tryCache ?? [Int: Bool]()
    
    guard var cache = AppEnvironment.current.cache[HRCache.hr_bookSaved] as? [Int: Bool] else {
        return books
    }
    
    for book in books {
        if booksSaved.contains(book.uuid) {
            cache[book.uuid] = true
        }
    }
    
    AppEnvironment.current.cache[HRCache.hr_bookSaved] = cache
    
    return books
}

private func fetchPrefferedColumns() -> Observable<BookLayoutTemplateSeletableRow> {
    Observable.just(AppEnvironment.current.keyValueStore.prefferredColumns)
        .map { BookLayoutTemplateSeletableRow(params: $0) }
}

private func cacheSavedLayout(_ layoutTemplate: BookLayoutTemplateSeletableRow) -> BookLayoutTemplateSeletableRow {
    AppEnvironment.current.keyValueStore.prefferredColumns = layoutTemplate.params
    
    return layoutTemplate
}
