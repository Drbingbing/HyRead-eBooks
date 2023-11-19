//
//  ShapeView.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//

import UIKit
import BaseToolbox

class ShapeView: UIView {
    
    override class var layerClass: AnyClass {
        CAShapeLayer.self
    }
    
    var shapeLayer: CAShapeLayer {
        layer as! CAShapeLayer
    }
    
    var path: UIBezierPath? {
        didSet {
            shapeLayer.path = path?.cgPath
        }
    }
    
    var fillColor: UIColor? {
        didSet {
            shapeLayer.fillColor = fillColor?.cgColor
        }
    }
    
    var strokeColor: UIColor? {
        didSet {
            shapeLayer.strokeColor = strokeColor?.cgColor
        }
    }

    @Proxy(\.shapeLayer.fillRule)
    var fillRule: CAShapeLayerFillRule

    @Proxy(\.shapeLayer.strokeStart)
    var strokeStart: CGFloat

    @Proxy(\.shapeLayer.strokeEnd)
    var strokeEnd: CGFloat

    @Proxy(\.shapeLayer.lineWidth)
    var lineWidth: CGFloat

    @Proxy(\.shapeLayer.miterLimit)
    var miterLimit: CGFloat

    @Proxy(\.shapeLayer.lineCap)
    var lineCap: CAShapeLayerLineCap

    @Proxy(\.shapeLayer.lineJoin)
    var lineJoin: CAShapeLayerLineJoin

    @Proxy(\.shapeLayer.lineDashPhase)
    var lineDashPhase: CGFloat

    @Proxy(\.shapeLayer.lineDashPattern)
    var lineDashPattern: [NSNumber]?

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            shapeLayer.fillColor = fillColor?.cgColor
            shapeLayer.strokeColor = strokeColor?.cgColor
        }
    }
}
