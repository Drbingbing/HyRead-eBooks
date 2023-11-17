//
//  MyBookViewModel.swift
//  HRLibrary
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import HRApi
import RxCocoa
import RxSwift

public struct MyBookCellRowValue: Hashable {
    public var book: Book
    public var saved: Bool
    
    public init(book: Book, saved: Bool) {
        self.book = book
        self.saved = saved
    }
}

public protocol MyBookViewModelInputs {
    
    /// Call to configure with a Book
    func configure(book: Book)
}

public protocol MyBookViewModelOutputs {
    
    /// Emits cover url that should be download image session.
    var coverURL: Driver<URL?> { get }
    
    /// Emits data for setting book title.
    var title: Driver<String> { get }
}

public protocol MyBookViewModelProtocol {
    
    var inputs: MyBookViewModelInputs { get }
    var outputs: MyBookViewModelOutputs { get }
}

public final class MyBookViewModel: MyBookViewModelProtocol, MyBookViewModelInputs, MyBookViewModelOutputs {
    
    public var outputs: MyBookViewModelOutputs { return self }
    public var inputs: MyBookViewModelInputs { return self }
    
    public init() {
        coverURL = bookSubject.map(\.coverURL)
            .compactMap { URL(string: $0) }
            .asDriver(onErrorJustReturn: nil)
        
        title = bookSubject.map(\.title)
            .asDriver(onErrorJustReturn: "")
    }
    
    // MARK: - Outpus
    public let coverURL: Driver<URL?>
    public let title: Driver<String>
    
    // MARK: - Inputs
    private let bookSubject = PublishSubject<Book>()
    public func configure(book: Book) {
        bookSubject.onNext(book)
    }
}
