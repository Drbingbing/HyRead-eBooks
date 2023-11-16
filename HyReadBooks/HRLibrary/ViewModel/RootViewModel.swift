//
//  RootViewModel.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import RxSwift
import RxCocoa

public typealias RootViewControllerIndex = Int

public enum RootViewControllerData {
    case collections
}

public enum TabBarItem {
    case collections(RootViewControllerIndex)
}

public struct TabBarItemsData {
    
    public let items: [TabBarItem]
    
    public init(items: [TabBarItem]) {
        self.items = items
    }
}

public protocol RootViewModelInputs {
    
    /// Call from the controller's `viewDidLoad` method.
    func viewDidLoad()
}

public protocol RootViewModelOutputs {
    
    /// Emits the array of view controllers that should be set on the tab bar.
    var viewControllers: Observable<[RootViewControllerData]> { get }
    
    /// Emits data for setting tab bar item styles.
    var tabBarItemsData: Observable<TabBarItemsData> { get }
}

public protocol RootViewModelProtocol {
    var inputs: RootViewModelInputs { get }
    var outputs: RootViewModelOutputs { get }
}


public final class RootViewModel: RootViewModelProtocol, RootViewModelInputs, RootViewModelOutputs {
    
    public init() {
        viewControllers = viewDidLoadSubject.map { _ in generateStandardViewControllers() }
        tabBarItemsData = viewDidLoadSubject.map { _ in tabData() }
    }
    
    public var inputs: RootViewModelInputs { return self }
    public var outputs: RootViewModelOutputs { return self }
    
    
    // MARK: - Outputs
    public let viewControllers: Observable<[RootViewControllerData]>
    public let tabBarItemsData: Observable<TabBarItemsData>
    
    // MARK: - Inputs
    private let viewDidLoadSubject = PublishSubject<Void>()
    public func viewDidLoad() {
        viewDidLoadSubject.onNext(())
    }
}


private func generateStandardViewControllers() -> [RootViewControllerData] {
    return [.collections]
}

private func tabData() -> TabBarItemsData {
    let items: [TabBarItem] = [
        .collections(0)
    ]
    
    return TabBarItemsData(items: items)
}
