//
//  SavedBookViewController.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//

import UIKit
import HRApi
import HRLibrary
import RxSwift

final class SavedBookViewController: UIViewController {
    
    let viewModel: SavedBooksViewModelProtocol = SavedBooksViewModel()
    
    private enum Section {
        case main
    }
    
    override func bindingUI() {
        view.addSubview(collectionView)
        
        collectionView.setCollectionViewLayout(savedBooksCollectionViewLayout(), animated: false)
        collectionView.register(BookCell.self, forCellWithReuseIdentifier: BookCell.reuseID)
        collectionView.delaysContentTouches = false
        collectionView.delegate = self
        
        navigationItem.title = "我的收藏"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.inputs.viewWillAppear()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds.inset(by: view.safeAreaInsets)
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


private func savedBooksCollectionViewLayout(columns: Int = 3) -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout.waterfall(
        columns: 3,
        interItemSpacing: 10,
        interGroupSpacing: 20,
        sectionInsets: UIEdgeInsets(20)
    )
}


// MARK: - BookCellDelegate {
extension SavedBookViewController: BookCellDelegate {
    
    func didSaveBookButtonTapped(book: Book, isSaved: Bool) {
        viewModel.inputs.setNeesdReload()
    }
}


// MARK: - UICollectionViewDelegate
extension SavedBookViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? BookCell {
            cell.delegate = self
        }
    }
    
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
