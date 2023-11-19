//
//  BookLayoutTemplateViewModel.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/19.
//

import Foundation
import HRLocalStorage
import RxSwift
import RxCocoa

public protocol BookLayoutTemplateViewModelInputs {
    func configure(template: BookLayoutTemplateSeletableRow)
    func viewDidLoad()
    func tapped(selectableRow: BookLayoutTemplateSeletableRow)
}

public protocol BookLayoutTemplateViewModelOutputs {
    var templates: Driver<[BookLayoutTemplateSeletableRow]> { get }
    var notifyDelegateOfSelectedRow: Observable<BookLayoutTemplateSeletableRow> { get}
}

public protocol BookLayoutTemplateViewModelProtocol {
    var inputs: BookLayoutTemplateViewModelInputs { get }
    var outputs: BookLayoutTemplateViewModelOutputs { get }
}

public final class BookLayoutTemplateViewModel: BookLayoutTemplateViewModelProtocol, BookLayoutTemplateViewModelInputs, BookLayoutTemplateViewModelOutputs {
    
    public init() {
        
        let configureTemplates = viewDidLoadSubject
            .map(bookLayoutTemplates)
            
        let selectedTemplate = Observable.merge(seletableRowSubject, configureTemplateSubject)
        let templateToggle = configureTemplates
            .flatMapLatest { templates in
                selectedTemplate.map { updateLayoutTemplates(templates, selected: $0) }
            }
        
        templates = Observable.merge(templateToggle, configureTemplates)
            .asDriver(onErrorJustReturn: [])
        
        notifyDelegateOfSelectedRow = seletableRowSubject
    }
    
    public var inputs: BookLayoutTemplateViewModelInputs { return self }
    public var outputs: BookLayoutTemplateViewModelOutputs { return self }
    
    public let templates: Driver<[BookLayoutTemplateSeletableRow]>
    public let notifyDelegateOfSelectedRow: Observable<BookLayoutTemplateSeletableRow>
    
    private let viewDidLoadSubject = PublishSubject<Void>()
    public func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
    
    private let configureTemplateSubject = PublishSubject<BookLayoutTemplateSeletableRow>()
    public func configure(template: BookLayoutTemplateSeletableRow) {
        configureTemplateSubject.onNext(template)
    }
    
    private let seletableRowSubject = PublishSubject<BookLayoutTemplateSeletableRow>()
    public func tapped(selectableRow: BookLayoutTemplateSeletableRow) {
        seletableRowSubject.onNext(selectableRow)
    }
}

private func updateLayoutTemplates(_ templates: [BookLayoutTemplateSeletableRow], selected: BookLayoutTemplateSeletableRow) -> [BookLayoutTemplateSeletableRow] {
    
    return templates.map {
        BookLayoutTemplateSeletableRow(params: $0.params, isSelected: $0.params == selected.params)
    }
}

private func bookLayoutTemplates() -> [BookLayoutTemplateSeletableRow] {
    let templates: [BookLayoutTemplateParams] = [2, 3]
    return templates.map {
        BookLayoutTemplateSeletableRow(
            params: $0, 
            isSelected: AppEnvironment.current.keyValueStore.prefferredColumns == $0
        )
    }
}
