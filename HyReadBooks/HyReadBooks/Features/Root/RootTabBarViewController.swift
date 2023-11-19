//
//  RootTabBarViewController.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/16.
//

import UIKit
import RxSwift
import HRLibrary

final class RootTabBarViewController: UITabBarController {
    
    let viewModel: RootViewModelProtocol = RootViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
    }
    
    override func bindStyles() {
        view.backgroundColor = .white
    }
    
    override func bindingUI() {
        delegate = self
    }
    
    override func bindingViewModel() {
        viewModel.outputs.viewControllers
            .map { $0.map { RootTabBarViewController.viewController(from: $0) } }
            .map { $0.map(UINavigationController.init(rootViewController:)) }
            .subscribe { [weak self] in
                self?.setViewControllers($0, animated: false)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.tabBarItemsData
            .subscribe { [weak self] in
                self?.setTabBarItemStyles($0)
            }
            .disposed(by: disposeBag)
    }
    
    private func setTabBarItemStyles(_ data: TabBarItemsData) {
        for item in data.items {
            switch item {
            case let .collections(rootViewControllerIndex):
                tabBarItem(at: rootViewControllerIndex).ifLet(collectionsTabBarItemStyle)
            case let .savedBooks(rootViewControllerIndex):
                tabBarItem(at: rootViewControllerIndex).ifLet(savedBooksTabBarItemStyle)
            }
        }
    }
    
    private func tabBarItem(at atIndex: Int) -> UITabBarItem? {
        if (tabBar.items?.count ?? 0) > atIndex {
            if let item = tabBar.items?[atIndex] {
                return item
            }
        }
        return nil
    }
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
}


extension RootTabBarViewController {
    
    fileprivate static func viewController(from rootViewController: RootViewControllerData) -> UIViewController {
        switch rootViewController {
        case .collections: MyBooksViewController()
        case .savedBooks: SavedBookViewController()
        }
    }
}

private func collectionsTabBarItemStyle(_ tabBarItem: UITabBarItem) {
    tabBarItem.title = "書櫃"
    tabBarItem.image = UIImage(systemName: "book")
}

private func savedBooksTabBarItemStyle(_ tabBarItem: UITabBarItem) {
    tabBarItem.title = "收藏"
    tabBarItem.image = UIImage(systemName: "heart")
}


extension RootTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(
        _ tabBarController: UITabBarController,
        animationControllerForTransitionFrom fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if let fromIndex = viewControllers?.firstIndex(of: fromVC),
           let toIndex = viewControllers?.firstIndex(of: toVC) {
            return CrossDissolveTransitionAnimator(direction: fromIndex < toIndex ? .right : .left)
        }
        return CrossDissolveTransitionAnimator()
    }
}
