//
//  BookCell.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/16.
//

import UIKit
import HRApi
import HRLibrary
import RxSwift
import RxCocoa
import Kingfisher

protocol BookCellDelegate: AnyObject {
    func didSaveBookButtonTapped(book: Book, isSaved: Bool)
}

final class BookCell: UICollectionViewCell {
    
    weak var delegate: BookCellDelegate?
    
    static let reuseID = "BookCell"
    
    private lazy var saveButton = { UIButton(type: .custom) }()
    private lazy var imageView = { UIImageView(frame: .zero) }()
    private lazy var titleLabel = { UILabel(frame: .zero) }()
    
    private let viewModel: MyBookViewModelProtocol = MyBookViewModel()
    private let watchBookViewModel: WatchBookViewModelProtocol = WatchBookViewModel()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(saveButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.4).isActive = true
        imageView.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        saveButton.setImage(UIImage(named: "icon_saved"), for: .selected)
        saveButton.setImage(UIImage(named: "icon_unsaved"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.tintColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
        
        contentView.backgroundColor = .white
        contentView.cornerRadius = 6
        contentView.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 6)
        contentView.shadowColor = .black.withAlphaComponent(0.1)
        contentView.shadowOffset = CGSize(width: 0, height: 2)
        contentView.shadowOpacity = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func bindingViewModel() {
        
        viewModel.outputs.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.coverURL
            .drive { [weak self] url in
                self?.imageView.kf.setImage(with: url, options: [.loadDiskFileSynchronously])
            }
            .disposed(by: disposeBag)
        
        watchBookViewModel.outputs.saveButtonSelected
            .drive(saveButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        watchBookViewModel.outputs.generateImpactFeedback
            .drive { _ in
                generateImpactFeedback()
            }
            .disposed(by: disposeBag)
        
        watchBookViewModel.outputs.saveButtonSelectedHint
            .drive { [weak self] hint in
                self?.showSnackbar(message: hint)
            }
            .disposed(by: disposeBag)
        
        watchBookViewModel.outputs.saveButtonDelegate
            .subscribe { [weak self] book, isSaved in
                self?.delegate?.didSaveBookButtonTapped(book: book, isSaved: isSaved)
            }
            .disposed(by: disposeBag)
    }
    
    func populate(book: Book) {
        bindingViewModel()
        
        watchBookViewModel.inputs.configure(book: book)
        viewModel.inputs.configure(book: book)
    }
    
    @objc private func saveButtonTapped(_ sender: UIButton) {
        watchBookViewModel.inputs.saveButtonTapped(selected: sender.isSelected)
    }
}

