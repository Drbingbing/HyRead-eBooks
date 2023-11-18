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
}

public protocol MyBooksViewModelOutputs {
    
    /// Emits the array of books that should be set on collectionview.
    var books: Driver<[Book]> { get }
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
        books = Observable.merge(store, remote)
            .withLatestFrom(savedBooks) { cacheSavedBooks($1, books: $0) }
            .asDriver(onErrorJustReturn: [])
    }
    
    public var inputs: MyBooksViewModelInputs { return self }
    public var outputs: MyBooksViewModelOutputs { return self }
    
    // MARK: - Outputs
    public let books: Driver<[Book]>
    
    // MARK: - Inputs
    private let viewDidLoadSubject = PublishSubject<Void>()
    public func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
    
    private let saveBookSubject = PublishSubject<(book: Book, shouldSave: Bool)>()
    public func saveBook(_ book: Book, shouldSave: Bool) {
        saveBookSubject.onNext((book, shouldSave))
    }
}

private func asBook(_ cdBook: CDBook) -> Book {
    Book(
        uuid: Int(cdBook.uuid),
        title: cdBook.title ?? "",
        coverURL: cdBook.coverURL ?? "",
        publishDate: cdBook.publishDate ?? "",
        publisher: cdBook.publisher ?? "",
        author: cdBook.author ?? ""
    )
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
