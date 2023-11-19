//
//  BookLayoutTemplateSeletableRow.swift
//  HyReadBooks
//
//  Created by Bing Bing on 2023/11/19.
//

import Foundation
import HRLocalStorage

public struct BookLayoutTemplateSeletableRow: Hashable {
    public var isSelected: Bool
    public var params: BookLayoutTemplateParams
    
    public init(params: BookLayoutTemplateParams, isSelected: Bool = false) {
        self.isSelected = isSelected
        self.params = params
    }
}
