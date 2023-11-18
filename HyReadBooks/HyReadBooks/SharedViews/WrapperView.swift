//
//  WrapperView.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/18.
//

import UIKit
import BaseToolbox

class WrapperView<V: UIView>: UIView {
    var contentView: V

    var inset: UIEdgeInsets = .zero {
        didSet {
            guard inset != oldValue else { return }
            setNeedsLayout()
        }
    }
    
    init() {
        contentView = V()
        super.init(frame: .zero)
        addSubview(contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frameWithoutTransform = bounds.inset(by: inset)
        if shadowOpacity > 0 {
            shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        }
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.sizeThatFits(size.inset(by: inset)).inset(by: -inset)
    }
}
