//
//  CrossDissolveTransitionAnimator.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//
import UIKit

internal enum ShiftDirection {
    case right
    case left
    case none
}

internal final class CrossDissolveTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let direction: ShiftDirection
    
    init(direction: ShiftDirection = .none) {
        self.direction = direction
        super.init()
    }
    
    internal func transitionDuration(using _: UIViewControllerContextTransitioning?)
    -> TimeInterval {
        return 0.15
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        else {
            return
        }
        
        var fromTransform: CGAffineTransform
        var toTransform: CGAffineTransform
        
        switch direction {
        case .right:
            fromTransform = CGAffineTransform(translationX: 25, y: 0)
            toTransform = CGAffineTransform(translationX: -25, y: 0)
        case .left:
            fromTransform = CGAffineTransform(translationX: -25, y: 0)
            toTransform = CGAffineTransform(translationX: 25, y: 0)
        case .none:
            fromTransform = .identity
            toTransform = .identity
        }
        
        fromVC.view.transform = .identity
        
        toVC.view.alpha = 0
        toVC.view.transform = fromTransform
        
        transitionContext.containerView.addSubview(fromVC.view)
        transitionContext.containerView.addSubview(toVC.view)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            delay: 0,
            options: .curveEaseOut,
            animations: {
                fromVC.view.alpha = 0
                fromVC.view.transform = toTransform
                toVC.view.alpha = 1
                toVC.view.transform = .identity
            },
            completion: { _ in
                fromVC.view.transform = .identity
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}
