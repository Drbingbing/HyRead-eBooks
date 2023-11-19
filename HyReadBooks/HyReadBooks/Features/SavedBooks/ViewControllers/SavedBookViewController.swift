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
        
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
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
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, repeatingSubitem: item, count: 3
        )
        
        group.interItemSpacing = .flexible(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = .init(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        return UICollectionViewCompositionalLayout(section: section)
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
