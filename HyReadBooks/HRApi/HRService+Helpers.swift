//
//  HRService+Helpers.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import RxCocoa

extension HRService {
    
    private static let session = URLSession(configuration: .default)
    
    func request<M: Decodable>(_ route: Route) -> Signal<Result<M, ErrorEnvelope>> {
        let properties = route.requestProperties
        
        guard let URL = URL(string: properties.path, relativeTo: serverConfig.apiBaseURL as URL) else {
            fatalError(
                "URL(string: \(properties.path), relativeToURL: \(serverConfig.apiBaseURL)) == nil"
            )
        }
        
        return HRService.session.rx_dataResponse(
            preparedRequest(for: URL, method: properties.method)
        )
        .flatMap(decodeModel)
    }
}
