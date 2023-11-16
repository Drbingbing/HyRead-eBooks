//
//  Service.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation

public struct HRService: ServiceProtocol {
    
    public var serverConfig: ServerConfigProtocol
    
    public init(serverConfig: ServerConfigProtocol = ServerConfig.production) {
        self.serverConfig = serverConfig
    }
}
