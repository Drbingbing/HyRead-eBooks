//
//  CoreDataStack.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData

public protocol CoreDataStackProtocol {
    
    var persistentContainer: NSPersistentContainer { get }
}

public final class CoreDataStack: CoreDataStackProtocol {
    
    internal static let shared = CoreDataStack()
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let bundle = Bundle(for: CoreDataStack.self)
        guard let url = bundle.url(forResource: "Model", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError()
        }
        
        let container = NSPersistentContainer(name: "Model", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("[HRLocalStorage] loading container error: \(error)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergePolicy.overwrite
        
        return container
    }()
    
    public init() {}
}
