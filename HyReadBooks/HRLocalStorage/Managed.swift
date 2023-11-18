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
    
    static func fetch(
        in context: NSManagedObjectContext,
        configurationBlock: (NSFetchRequest<Self>) -> Void = { _ in }
    ) -> [Self] {
        let request = NSFetchRequest<Self>(entityName: Self.entityName)
        configurationBlock(request)
        return (try? context.fetch(request)) ?? []
    }
}

extension CDBook: Managed {}
extension CDSavedBook: Managed {}
