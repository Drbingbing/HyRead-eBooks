//
//  Extension+UICollectionViewCompositionalLayout.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//

import UIKit

extension UICollectionViewCompositionalLayout {
    
    static func waterfall(
        columns: Int,
        interItemSpacing: CGFloat = 0,
        interGroupSpacing: CGFloat = 0,
        sectionInsets: UIEdgeInsets = .zero
    ) -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/CGFloat(columns)),
            heightDimension: .estimated(100)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, repeatingSubitem: item, count: columns
        )
        
        group.interItemSpacing = .flexible(interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(
            top: sectionInsets.top,
            leading: sectionInsets.left,
            bottom: sectionInsets.bottom,
            trailing: sectionInsets.right
        )
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
