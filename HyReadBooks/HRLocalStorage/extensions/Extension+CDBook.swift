//
//  CDBook.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData
import HRApi

extension CDBook {
    
    static func eraseAll(into context: NSManagedObjectContext) {
        let objects = fetch(in: context)
        for object in objects {
            context.delete(object)
        }
    }
    
    @discardableResult
    static func insert(into context: NSManagedObjectContext, books: [Book]) -> [CDBook] {
        books.enumerated().map { insert(into: context, book: $0.element, id: $0.offset) }
    }
    
    static func insert(into context: NSManagedObjectContext, book: Book, id: Int) -> CDBook {
        let object: CDBook = context.insertObject()
        object.uuid = Int32(book.uuid)
        object.setValue(id, forKey: "sortID")
        object.setValue(book.title, forKey: "title")
        object.setValue(book.coverURL, forKey: "coverURL")
        object.setValue(book.publishDate, forKey: "publishDate")
        object.setValue(book.publisher, forKey: "publisher")
        object.setValue(book.author, forKey: "author")
        
        return object
    }
}
