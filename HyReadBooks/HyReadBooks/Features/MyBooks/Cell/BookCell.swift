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
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let viewModel: BookCellViewModelProtocol = BookCellViewModel()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 1.4).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        titleLabel.font = .systemFont(ofSize: 14)
        
        viewModel.outputs.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.outputs.coverURL
            .drive { [weak self] url in
                self?.imageView.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.borderColor = UIColor.separator.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 10).cgPath
        layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 1
        
        imageView.layer.cornerRadius = 10
    }
    
    func populate(book: Book) {
        viewModel.inputs.configure(book: book)
    }
}

