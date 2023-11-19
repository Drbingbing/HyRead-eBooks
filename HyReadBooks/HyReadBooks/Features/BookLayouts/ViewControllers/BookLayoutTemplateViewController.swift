//
//  BookLayoutTemplateViewController.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//

import UIKit
import HRLibrary
import HRLocalStorage
import RxSwift

protocol BookLayoutTemplateViewControllerDelegate:AnyObject {
    func bookLayoutTemplate(_ viewController: BookLayoutTemplateViewController, selectedRow: BookLayoutTemplateSeletableRow)
}

final class BookLayoutTemplateViewController: UIViewController {
    
    static func instantiate(template: BookLayoutTemplateSeletableRow) -> BookLayoutTemplateViewController {
        let vc = BookLayoutTemplateViewController()
        return vc
    }
    
    let viewModel: BookLayoutTemplateViewModelProtocol = BookLayoutTemplateViewModel()
    weak var delegate: BookLayoutTemplateViewControllerDelegate?
    
    private enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.inputs.viewDidLoad()
    }
    
    override func bindingUI() {
        view.addSubview(collectionView)
        collectionView.register(BookLayoutTemplateCell.self, forCellWithReuseIdentifier: BookLayoutTemplateCell.reuseID)
        collectionView.setCollectionViewLayout(selectableLayoutCollectionViewLayout(), animated: false)
        collectionView.delegate = self
        navigationItem.title = "排版樣式"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .done,
            primaryAction: UIAction { [weak self] _ in self?.dismiss(animated: true) }
        )
    }
    
    override func bindStyles() {
        view.backgroundColor = .white
    }
    
    override func bindingViewModel() {
        viewModel.outputs.templates
            .drive { [weak self] templates in
                var snapshot = NSDiffableDataSourceSnapshot<Section, BookLayoutTemplateSeletableRow>()
                snapshot.appendSections([.main])
                snapshot.appendItems(templates, toSection: .main)
                self?.dataSource.apply(snapshot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)
        viewModel.outputs.notifyDelegateOfSelectedRow
            .subscribe { [weak self] selectedRow in
                guard let self else { return }
                self.delegate?.bookLayoutTemplate(self, selectedRow: selectedRow)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds.inset(by: view.safeAreaInsets)
    }
    
    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var dataSource = UICollectionViewDiffableDataSource<Section, BookLayoutTemplateSeletableRow>(collectionView: collectionView) { collectionView, indexPath, selectableRow in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookLayoutTemplateCell.reuseID, for: indexPath) as! BookLayoutTemplateCell
        cell.populate(selectableRow: selectableRow)
        return cell
    }
}

private func selectableLayoutCollectionViewLayout() -> UICollectionViewLayout {
    return UICollectionViewCompositionalLayout.waterfall(
        columns: 2,
        interItemSpacing: 20,
        interGroupSpacing: 40,
        sectionInsets: UIEdgeInsets(20)
    )
}

// MARK: - UICollectionViewDelegate
extension BookLayoutTemplateViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectableRow = dataSource.itemIdentifier(for: indexPath) {
            viewModel.inputs.tapped(selectableRow: selectableRow)
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
