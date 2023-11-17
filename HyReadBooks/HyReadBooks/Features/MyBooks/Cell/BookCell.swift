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

final class BookCell: UICollectionViewCell {
    
    static let reuseID = "BookCell"
    
    private lazy var saveButton = { UIButton(type: .custom) }()
    private lazy var imageView = { UIImageView(frame: .zero) }()
    private lazy var titleLabel = { UILabel(frame: .zero) }()
    
    private let viewModel: MyBookViewModelProtocol = MyBookViewModel()
    private let watchBookViewModel: WatchBookViewModelProtocol = WatchBookViewModel()
    private let disposeBag = DisposeBag()
    
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
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2).isActive = true
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 3
        
        saveButton.setImage(UIImage(named: "icon_saved"), for: .selected)
        saveButton.setImage(UIImage(named: "icon_unsaved"), for: .normal)
        saveButton.tintColor = .white
        
        viewModel.outputs.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.coverURL
            .drive { [weak self] url in
                self?.imageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
        
        watchBookViewModel.outputs.saveButtonSelected
            .drive(saveButton.rx.isSelected)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .white
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 6
    }
    
    func populate(value: MyBookCellRowValue) {
        watchBookViewModel.inputs.configure(saved: value.saved)
        viewModel.inputs.configure(book: value.book)
    }
}

