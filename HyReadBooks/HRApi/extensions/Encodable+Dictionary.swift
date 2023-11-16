//
//  Encodable+Dictionary.swift
//  HRApi
//
//  Created by BingBing on 2023/11/16.
//

import Foundation

extension Encodable {
    var dictionaryRepresentation: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
            .flatMap { $0 as? [String: Any] }
    }
}
