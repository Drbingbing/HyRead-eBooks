//
//  BookCellViewModel.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import HRApi
import RxCocoa
import RxSwift

public protocol BookCellViewModelInputs {
    
    /// Call to configure with a Book
    func configure(book: Book)
}

public protocol BookCellViewModelOutputs {
    
    /// Emits cover url that should be download image session.
    var coverURL: Driver<URL?> { get }
    
    /// Emits data for setting book title.
    var title: Driver<String> { get }
}

public protocol BookCellViewModelProtocol {
    
    var inputs: BookCellViewModelInputs { get }
    var outputs: BookCellViewModelOutputs { get }
}

public final class BookCellViewModel: BookCellViewModelProtocol, BookCellViewModelInputs, BookCellViewModelOutputs {
    
    public var outputs: BookCellViewModelOutputs { return self }
    public var inputs: BookCellViewModelInputs { return self }
    
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
