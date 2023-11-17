//
//  LocalStorage+Helpers.swift
//  HRLocalStorage
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

extension LocalStorage {
    
    func request<Object: NSManagedObject & Managed>(_ object: Object.Type) -> Signal<Result<[Object], Error>> {
        Observable.create { observer in
            
            let context = coreStack.persistentContainer.newBackgroundContext()
            context.perform {
                let result = object.fetch(in: context)
                observer.onNext(.success(result))
            }
            
            return Disposables.create()
        }
        .asSignal { error in
            Signal.just(.failure(error))
        }
    }
}
