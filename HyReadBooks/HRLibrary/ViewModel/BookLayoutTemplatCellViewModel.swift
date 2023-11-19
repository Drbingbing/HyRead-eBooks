//
//  BookLayoutTemplatCellViewModel.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/19.
//

import Foundation
import HRLocalStorage
import RxSwift
import RxCocoa

public protocol BookLayoutTemplatCellViewModelInputs {
    func configure(selectableRow: BookLayoutTemplateSeletableRow)
}

public protocol BookLayoutTemplatCellViewModelOutputs {
    
    /// Emits current template selected.
    var isSelected: Driver<Bool> { get }
    
    /// Emits template params title.
    var title: Driver<String> { get }
    
    /// Emits the template should display how many columns.
    var columns: Driver<Int> { get }
}

public protocol BookLayoutTemplatCellViewModelProtocol {
    var inputs: BookLayoutTemplatCellViewModelInputs { get }
    var outputs: BookLayoutTemplatCellViewModelOutputs { get }
}

public final class BookLayoutTemplatCellViewModel: BookLayoutTemplatCellViewModelProtocol, BookLayoutTemplatCellViewModelOutputs, BookLayoutTemplatCellViewModelInputs {
    
    public var inputs: BookLayoutTemplatCellViewModelInputs { return self }
    public var outputs: BookLayoutTemplatCellViewModelOutputs { return self }
    
    public init() {
        isSelected = templateSubject.map(\.isSelected)
            .asDriver(onErrorJustReturn: false)
        
        title = templateSubject.map(\.params)
            .map { "樣式\($0 - 1)" }
            .asDriver(onErrorJustReturn: "")
        
        columns = templateSubject.map(\.params)
            .asDriver(onErrorJustReturn: 2)
    }
    
    public let isSelected: Driver<Bool>
    public let title: Driver<String>
    public let columns: Driver<Int>
    
    private let templateSubject = PublishSubject<BookLayoutTemplateSeletableRow>()
    public func configure(selectableRow: BookLayoutTemplateSeletableRow) {
        templateSubject.onNext(selectableRow)
    }
}
