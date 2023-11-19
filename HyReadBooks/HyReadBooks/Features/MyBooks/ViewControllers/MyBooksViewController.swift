//
//  MyBooksViewController.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/16.
//

import UIKit
import HRApi
import HRLibrary
import RxCocoa
import RxSwift

final class MyBooksViewController: UIViewController {
    
    let viewModel: MyBooksViewModelProtocol = MyBooksViewModel()
    
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
    }
    
    override func bindingUI() {
        view.addSubview(collectionView)
        
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseID)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.delaysContentTouches = false
        
        navigationItem.title = "我的書櫃"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "",
            image: UIImage(systemName: "ellipsis.circle"),
            target: self,
            action: #selector(didRightBarButtonTapped)
        )
    }
    
    override func bindingViewModel() {
        viewModel.outputs.books
            .drive { [weak self] books in
                var snapshot = NSDiffableDataSourceSnapshot<Section, Book>()
                snapshot.appendSections([.main])
                snapshot.appendItems(books)
                self?.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)
        viewModel.outputs.goToLayoutTemplate
            .subscribe { [weak self] template in
                let vc = BookLayoutTemplateViewController.instantiate(template: template)
                vc.delegate = self
                self?.present(UINavigationController(rootViewController: vc), animated: true)
            }
            .disposed(by: disposeBag)
        
        viewModel.outputs.preferredColumns
            .drive { [weak self] columns in
                self?.collectionView.setCollectionViewLayout(myBooksCollectionViewLayout(columns: columns), animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
    
    @objc private func didRightBarButtonTapped() {
        viewModel.inputs.layoutButtonTapped()
    }
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, Book>(collectionView: collectionView) { collectionView, indexPath, book in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCell.reuseID, for: indexPath) as! BookCell
        cell.populate(book: book)
        return cell
    }
}

private func myBooksCollectionViewLayout(columns: Int = 3) -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout.waterfall(
        columns: columns,
        interItemSpacing: 10,
        interGroupSpacing: 20,
        sectionInsets: UIEdgeInsets(20)
    )
}


// MARK: - UICollectionViewDelegate
extension MyBooksViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity.scaledBy(x: 0.96, y: 0.96)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        }
    }
}

// MARK: -
extension MyBooksViewController: BookLayoutTemplateViewControllerDelegate {
    
    func bookLayoutTemplate(_ viewController: BookLayoutTemplateViewController, selectedRow: BookLayoutTemplateSeletableRow) {
        viewModel.inputs.tapped(selectableRow: selectedRow)
    }
}
