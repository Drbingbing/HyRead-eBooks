//
//  BookLayoutTemplateCell.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//

import UIKit
import HRLocalStorage
import HRLibrary
import BaseToolbox
import RxSwift
import RxCocoa

final class BookLayoutTemplateCell: UICollectionViewCell {
    
    static let reuseID = "BookLayoutTemplateCell"
    
    private lazy var badgeImageView = { UIImageView(frame: .zero) }()
    private lazy var titleLabel = { UILabel(frame: .zero) }()
    private lazy var templateView = { BookLayoutTemplateView(frame: .zero) }()
    
    private var disposeBag = DisposeBag()
    private var viewModel: BookLayoutTemplatCellViewModelProtocol = BookLayoutTemplatCellViewModel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(templateView)
        contentView.addSubview(badgeImageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40).isActive = true
        titleLabel.topAnchor.constraint(equalTo: templateView.bottomAnchor, constant: 24).isActive = true
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemPink
        
        templateView.translatesAutoresizingMaskIntoConstraints = false
        templateView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 48).isActive = true
        templateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        templateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        templateView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        badgeImageView.translatesAutoresizingMaskIntoConstraints = false
        badgeImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
        badgeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
        badgeImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        badgeImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        badgeImageView.tintColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .white
        contentView.borderWidth = 1
        contentView.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    private func bindingViewModel() {
        viewModel.outputs.columns
            .drive(templateView.rx.columns)
            .disposed(by: disposeBag)
        viewModel.outputs.isSelected
            .drive { [weak self] isSelected in
                self?.contentView.borderColor = isSelected ? .systemPink : .clear
                self?.badgeImageView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : nil
            }
            .disposed(by: disposeBag)
        viewModel.outputs.title
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func populate(selectableRow: BookLayoutTemplateSeletableRow) {
        bindingViewModel()
        viewModel.inputs.configure(selectableRow: selectableRow)
    }
}
