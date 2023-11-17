//
//  CDMyBook.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData
import HRApi

extension CDMyBook {
    
    static func insert(into context: NSManagedObjectContext, books: [Book]) {
        
    }
    
    static func insert(into context: NSManagedObjectContext, book: Book) -> CDMyBook {
        let object: CDMyBook = context.insertObject()
        object.id = UUID().uuidString
        object.
    }
}
