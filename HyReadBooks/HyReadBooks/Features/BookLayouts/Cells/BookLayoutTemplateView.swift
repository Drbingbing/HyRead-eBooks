//
//  BookLayoutTemplateView.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//

import UIKit

final class BookLayoutTemplateView: UIView {
    
    private var shapes: [ShapeView] = []
    
    var columns: Int = 3 {
        didSet {
            subviews.forEach { $0.removeFromSuperview() }
            shapes = (0..<columns).map { _ in bookTemplateStlye() }
            shapes.forEach { addSubview($0) }
            setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutItems()
    }
    
    private func layoutItems() {
        let columns = CGFloat(columns)
        let width: CGFloat = 26
        let spacing: CGFloat = 6
        let edges: CGFloat = (bounds.width - (width * columns + spacing)) / 2
        let height = bounds.height
        let size = CGSize(width: width, height: height)
        
        var origin = CGPoint(x: edges, y: 0)
        for shape in shapes {
            shape.frame = CGRect(origin: origin, size: size)
            shape.path = UIBezierPath(roundedRect: shape.bounds, cornerRadius: 4)
            
            origin.x += size.width + spacing
        }
    }
}

private func bookTemplateStlye() -> ShapeView {
    let view = ShapeView()
    view.fillColor = .white
    view.lineCap = .round
    view.strokeColor = .secondaryLabel
    view.lineWidth = 1
    return view
}
