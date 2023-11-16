//
//  ServerConfig.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation

public protocol ServerConfigProtocol {
    var apiBaseURL: URL { get }
}

func ==(lhs: ServerConfigProtocol, rhs: ServerConfigProtocol) -> Bool {
    return lhs.apiBaseURL == rhs.apiBaseURL
}

public struct ServerConfig: ServerConfigProtocol {
    
    public let apiBaseURL: URL
    
    public init(apiBaseURL: URL) {
        self.apiBaseURL = apiBaseURL
    }
    
    public static let production: ServerConfigProtocol = ServerConfig(
        apiBaseURL: URL(string: "https://mservice.ebook.hyread.com.tw")!
    )
}
