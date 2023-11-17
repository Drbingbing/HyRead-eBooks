//
//  LocalStorage.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData
import RxCocoa
import RxSwift

public struct LocalStorage: LocalStorageProtocol {
    
    internal var coreStack: CoreDataStackProtocol = CoreDataStack.shared
    
    public init() {}
    
    public func fetchMyBooks() -> Signal<Result<[CDMyBook], Error>> {
        return request(CDMyBook.self)
    }
}
