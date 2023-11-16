//
//  Dictionary.swift
//  HRApi
//
//  Created by BingBing on 2023/11/16.
//

import Foundation

internal extension Dictionary {
    
    /// Merges `self` with `other`, but all values from `other` trump the values in `self`.
    ///
    /// - parameter other: Another dictionary.
    ///
    /// - returns: A merged dictionary.
    func withAllValuesFrom(_ other: Dictionary) -> Dictionary {
      var result = self
      other.forEach { result[$0] = $1 }
      return result
    }
}
