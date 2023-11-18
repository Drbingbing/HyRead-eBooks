//
//  UIView+SnackBar.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/18.
//

import UIKit
import Popover

extension UIView {
    
    func showSnackbar(message: String) {
        PopoverManager.shared.dismiss()
        
        let label = WrapperView<UILabel>()
        label.inset = UIEdgeInsets(h: 12, v: 8)
        label.contentView.numberOfLines = 0
        label.contentView.text = message
        label.contentView.textColor = .white
        label.contentView.font = .systemFont(ofSize: 14)
        label.backgroundColor = .systemGray
        
        var config = PopoverConfig(container: PopoverConfig.defaultContainer!)
        config.backgroundOverlayColor = .clear
        config.positioning.verticalAlignment = .end
        config.showTriangle = false
        config.backgroundColor = .clear
        config.cornerRadius = 6
        config.shadowColor = .black.withAlphaComponent(0.15)
        config.shadowOpacity = 1
        config.transitionType = .notification
        config.duration = 1
        config.positioning.verticalAlignment = .end
        config.sourceRect = CGRect(origin: config.container.bounds.bottomCenter, size: .zero)
        config.showBackgroundOverlay = false
        PopoverManager.shared.show(popover: label, config: config)
    }
}
