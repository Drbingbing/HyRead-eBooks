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
    
    public func fetchMyBooks() -> Signal<Result<[CDMyBook], Error>> {
        return request(CDMyBook.self)
    }
    
    public func saveMyBooks(_ books: [Book]) -> Signal<Bool> {
        Observable.create { observer in
            let context = coreStack.persistentContainer.viewContext
            context.performChanges {
                CDMyBook.eraseAll(into: context)
                CDMyBook.insert(into: context, books: books)
                observer.onNext(true)
            }
            
            return Disposables.create {}
        }.asSignal(onErrorJustReturn: false)
    }
}
