//
//  HRService.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import RxCocoa

public struct HRService: ServiceProtocol {
    
    public var serverConfig: ServerConfigProtocol
    
    public init(serverConfig: ServerConfigProtocol = ServerConfig.production) {
        self.serverConfig = serverConfig
    }
    
    public func userList() -> Signal<Result<[Book], ErrorEnvelope>> {
        return request(.userList)
    }
}
