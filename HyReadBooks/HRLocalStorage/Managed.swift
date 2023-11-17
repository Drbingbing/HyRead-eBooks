//
//  Managed.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData

protocol Managed: NSFetchRequestResult {
    
    static var entityName: String { get }
}

extension Managed where Self: NSManagedObject {
    
    static var entityName: String {
        return entity().name!
    }
    
    static func fetch(in context: NSManagedObjectContext) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "sortID", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }
}

extension CDMyBook: Managed {}
