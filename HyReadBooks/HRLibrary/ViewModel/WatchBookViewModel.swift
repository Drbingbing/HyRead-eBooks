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
    func configure(saved: Bool)
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
        saveButtonSelected = savedSubject.asDriver(onErrorJustReturn: false)
    }
    
    // MARK: - Outpus
    public let saveButtonSelected: Driver<Bool>
    
    // MARK: - Inputs
    private let savedSubject = PublishSubject<Bool>()
    public func configure(saved: Bool) {
        savedSubject.onNext(saved)
    }
}
