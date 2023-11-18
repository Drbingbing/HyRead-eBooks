//
//  HRCache.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/18.
//

import Foundation

public final class HRCache {
    
    private let cache = NSCache<NSString, AnyObject>()
    
    public static let hr_bookSaved = "book_saved"
    
    public init() {}
    
    public subscript(key: String) -> Any? {
        get {
            return self.cache.object(forKey: key as NSString)
        }
        set {
            if let newValue = newValue {
                self.cache.setObject(newValue as AnyObject, forKey: key as NSString)
            } else {
                self.cache.removeObject(forKey: key as NSString)
            }
        }
    }
    
    public func removeAllObjects() {
        self.cache.removeAllObjects()
    }
}
