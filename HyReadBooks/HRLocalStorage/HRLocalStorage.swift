//
//  HRLocalStorage.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData
import RxCocoa
import RxSwift
import HRApi

public struct HRLocalStorage: LocalStorageProtocol {
    
    internal var coreStack: CoreDataStackProtocol = CoreDataStack.shared
    
    public init() {}
    
    public func fetchMyBooks() -> Signal<[CDBook]> {
        Observable.create { observer in
            
            let context = coreStack.persistentContainer.viewContext
            context.perform {
                let result = CDBook.fetch(in: context) {
                    $0.sortDescriptors = [NSSortDescriptor(key: "sortID", ascending: true)]
                }
                observer.onNext(result)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
        .asSignal(onErrorJustReturn: [])
    }
    
    public func saveMyBooks(_ books: [Book]) -> Signal<Bool> {
        Observable.create { observer in
            let context = coreStack.persistentContainer.viewContext
            context.performChanges {
                CDBook.eraseAll(into: context)
                CDBook.insert(into: context, books: books)
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return Disposables.create {}
        }
        .asSignal(onErrorJustReturn: false)
    }
    
    public func addToCollections(_ book: Book) -> Signal<Bool> {
        Observable.create { observer in
            
            let context = coreStack.persistentContainer.viewContext
            context.performChanges {
                CDSavedBook.insert(into: context, book: book)
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return Disposables.create {}
        }
        .asSignal(onErrorJustReturn: false)
    }
    
    public func removeFromCollections(_ book: Book) -> Signal<Bool> {
        Observable.create { observer in
            
            let context = coreStack.persistentContainer.viewContext
            context.performChanges {
                let saved = CDSavedBook.fetch(in: context)
                if let object = saved.first(where: { $0.uuid == Int32(book.uuid) }) {
                    context.delete(object)
                }
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return Disposables.create {}
        }
        .asSignal(onErrorJustReturn: false)
    }
    
    public func fetchCollections() -> Signal<[CDSavedBook]> {
        Observable.create { observer in
            
            let context = coreStack.persistentContainer.viewContext
            context.performChanges {
                let saved = CDSavedBook.fetch(in: context)
                observer.onNext(saved)
                observer.onCompleted()
            }
            
            return Disposables.create {}
        }
        .asSignal(onErrorJustReturn: [])
    }
}
