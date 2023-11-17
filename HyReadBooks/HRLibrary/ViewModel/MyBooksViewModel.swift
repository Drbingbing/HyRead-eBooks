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
            .map { try $0.get() }
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
        books = Observable.zip(store, remote)
            .map(merge)
            .asDriver(onErrorJustReturn: [])
//        books = Observable.just([Book(
//            uuid: 0,
//            title: "藍色時期. 7",
//            coverURL: "https://webcdn2.ebook.hyread.com.tw/bookcover/270374978957267916620215022111051.jpg",
//            publishDate: "",
//            publisher: "",
//            author: "")]
//        ).asDriver(onErrorJustReturn: [])
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
}

private func asBook(_ cdBook: CDMyBook) -> Book {
    Book(
        uuid: Int(cdBook.uuid),
        title: cdBook.title ?? "",
        coverURL: cdBook.coverURL ?? "",
        publishDate: cdBook.publishDate ?? "",
        publisher: cdBook.publisher ?? "",
        author: cdBook.author ?? ""
    )
}

private func merge(store: [Book], remote: [Book]) -> [Book] {
    if !store.isEmpty {
        return store
    }
    
    return remote
}
