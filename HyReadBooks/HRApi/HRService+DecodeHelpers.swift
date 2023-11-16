//
//  HRService+Decode.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import RxCocoa

extension HRService {
    
    func decodeModel<T: Decodable>(_ jsonData: Result<Data, ErrorEnvelope>) -> Signal<Result<T, ErrorEnvelope>> {
        return Signal.just(jsonData)
            .flatMap {
                switch $0 {
                case let .success(data):
                    do {
                        let decodedObject = try JSONDecoder().decode(T.self, from: data)
                        return .just(Result<T, ErrorEnvelope>.success(decodedObject))
                    } catch {
                        return .just(Result<T, ErrorEnvelope>.failure(.couldNotDecodeJSON(error)))
                    }
                case let .failure(error):
                    return .just(Result<T, ErrorEnvelope>.failure(error))
                }
            }
    }
}
