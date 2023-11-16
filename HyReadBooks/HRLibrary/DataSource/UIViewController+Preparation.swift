//
//  UIViewController+Preparation.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//
import UIKit

private func swizzle(_ vc: UIViewController.Type) {
    [
        (#selector(vc.viewDidLoad), #selector(vc.hr_ViewDidLoad)),
        (#selector(vc.viewWillAppear(_:)), #selector(vc.hr_ViewWillAppear(_:)))
    ].forEach { original, swizzled in
        
        guard let originalMethod = class_getInstanceMethod(vc, original),
              let swizzledMethod = class_getInstanceMethod(vc, swizzled) else { return }
        
        let didAddViewDidLoadMethod = class_addMethod(
            vc,
            original,
            method_getImplementation(swizzledMethod),
            method_getTypeEncoding(swizzledMethod)
        )
        
        if didAddViewDidLoadMethod {
            class_replaceMethod(
                vc,
                swizzled,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod)
            )
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
}

private var hasSwizzled: Bool = false

extension UIViewController {
    
    public final class func doBadSwizzleStuff() {
        guard !hasSwizzled else { return }
        hasSwizzled = true
        swizzle(self)
    }
    
    @objc internal func hr_ViewDidLoad() {
        hr_ViewDidLoad()
        bindingViewModel()
        bindingUI()
    }
    
    @objc internal func hr_ViewWillAppear(_ animated: Bool) {
        hr_ViewWillAppear(animated)
        if !hasViewAppeared {
            bindStyles()
            hasViewAppeared = true
        }
    }
    
    @objc open func bindingViewModel() {}
    @objc open func bindStyles() {}
    @objc open func bindingUI() {}
    
    private struct AssociatedKeys {
        static var hasViewAppeared = "hasViewAppeared"
    }
    
    private var hasViewAppeared: Bool {
        get {
            withUnsafePointer(to: &AssociatedKeys.hasViewAppeared) {
                return objc_getAssociatedObject(self, $0) as? Bool ?? false
            }
        }
        set {
            withUnsafePointer(to: &AssociatedKeys.hasViewAppeared) {
                objc_setAssociatedObject(
                    self,
                    $0,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
}
