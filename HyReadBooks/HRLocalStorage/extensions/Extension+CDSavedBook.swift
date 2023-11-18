//
//  Extension+CDSavedBook.swift
//  HRLocalStorage
//
//  Created by Bing Bing on 2023/11/17.
//

import Foundation
import CoreData
import HRApi

extension CDSavedBook {
    
    @discardableResult
    static func insert(into context: NSManagedObjectContext, book: Book) -> CDSavedBook {
        let object: CDSavedBook = context.insertObject()
        object.uuid = Int32(book.uuid)
        
        return object
    }
}
