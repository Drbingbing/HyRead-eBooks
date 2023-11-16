//
//  Optional+Extension.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation

extension Optional {
    
    public func ifLet(_ projected: (Wrapped) -> Void) {
        if case let .some(wrapped) = self {
            projected(wrapped)
        }
    }
}
