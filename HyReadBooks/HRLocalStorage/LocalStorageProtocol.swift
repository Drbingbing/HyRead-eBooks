//
//  LocalStorageProtocol.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData
import RxCocoa
import HRApi

public protocol LocalStorageProtocol {
    
    func fetchMyBooks() -> Signal<Result<[CDMyBook], Error>>
    
    func saveMyBooks(_ books: [Book]) -> Signal<Bool>
}
