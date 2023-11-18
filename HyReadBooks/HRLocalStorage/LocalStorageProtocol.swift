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
    
    /// Fetch all books that storing local.
    func fetchMyBooks() -> Signal<[CDBook]>
    
    /// Save all books that retrieved from cloud.
    func saveMyBooks(_ books: [Book]) -> Signal<Bool>
    
    /// Add book to collection lists
    func addToCollections(_ book: Book) -> Signal<Bool>
    
    /// Remove book from collection list
    func removeFromCollections(_ book: Book) -> Signal<Bool>
    
    /// Fetch all saved collections
    func fetchCollections() -> Signal<[CDSavedBook]>
}
