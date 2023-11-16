//
//  ServiceProtocol.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation

public protocol ServiceProtocol {
    var serverConfig: ServerConfigProtocol { get }
    
    init(serverConfig: ServerConfigProtocol)
}

func ==(lhs: ServiceProtocol, rhs: ServiceProtocol) -> Bool {
    return lhs.serverConfig == rhs.serverConfig
}

extension ServiceProtocol {
    
    ///Prepares a request to be sent to the server.
    ///
    /// - parameter URL:    The URL to turn into a request and prepare.
    /// - parameter method: The HTTP verb to use for the request.
    /// - parameter query:  Additional query params that should be attached to the request.
    ///
    /// - returns: A new URL request that is properly configured for the server.
    public func preparedRequest(for url: URL, method: Method = .GET) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return preparedRequest(forRequest: request)
    }
    
    /// Prepares a URL request to be sent to the server.
    ///
    /// - parameter originalRequest: The request that should be prepared.
    /// - parameter queryString:     The GraphQL query string for the request.
    ///
    /// - returns: A new URL request that is properly configured for the server.
    public func preparedRequest(forRequest originalRequest: URLRequest) -> URLRequest {
        var request = originalRequest
        
        guard let URL = request.url else {
            return request
        }
        
        request.url = URL
        
        let currentHeaders = request.allHTTPHeaderFields ?? [:]
        request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(defaultHeaders)
        
        return request
    }
    
    internal var defaultHeaders: [String: String] {
        var headers: [String: String] = [:]
        
        headers["Content-Type"] = "application/json; charset=utf-8"
        
        return headers
    }
}
