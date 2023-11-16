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
//        books = viewDidLoadSubject.flatMap { AppEnvironment.current.apiService.userList() }
//            .map { try $0.get() }
//            .asDriver(onErrorJustReturn: [])
        books = Observable.just([Book(
            uuid: 0,
            title: "藍色時期. 7",
            coverURL: "https://webcdn2.ebook.hyread.com.tw/bookcover/270374978957267916620215022111051.jpg",
            publishDate: "",
            publisher: "",
            author: "")]
        ).asDriver(onErrorJustReturn: [])
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
