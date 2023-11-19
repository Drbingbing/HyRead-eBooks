//
//  KeyValueStore.swift
//  HRLocalStorage
//
//  Created by Bing Bing on 2023/11/19.
//

import Foundation

public enum AppKeys: String {
    case prefferredColumns = "com.HyReadBooks.KeyValueStore.prefferredColumns"
}

public protocol KeyValueStoreProtocol: AnyObject {
    
    func set(_ value: Int, forKey defaultName: String)
    
    func object(forKey defaultName: String) -> Any?
    
    var prefferredColumns: Int { get }
}

extension KeyValueStoreProtocol {
    
    public var prefferredColumns: Int {
        get {
            return self.object(forKey: AppKeys.prefferredColumns.rawValue) as? Int ?? 3
        }
        set {
          self.set(newValue, forKey: AppKeys.prefferredColumns.rawValue)
        }
    }
}

extension UserDefaults: KeyValueStoreProtocol {}
