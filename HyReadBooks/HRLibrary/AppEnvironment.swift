//
//  AppEnvironment.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import HRApi
import HRLocalStorage

/// A global stack that captures the current state of global objects that the app wants access to.
public struct AppEnvironment {
    
    fileprivate static var stack: [Environment] = [Environment()]
    
    // The most recent environment on the stack.
    public static var current: Environment! {
        return stack.last
    }
    
    public static func updateServerConfig(_ config: ServerConfigProtocol) {
        let service = HRService(serverConfig: config)
        replaceCurrentEnvironment(apiService: service)
    }
    
    public static func replaceCurrentEnvironment(
        apiService: ServiceProtocol = AppEnvironment.current.apiService,
        localStorage: LocalStorageProtocol = AppEnvironment.current.localStorage
    ) {
        replaceCurrentEnvironment(
            Environment(
                apiService: apiService,
                localStorage: localStorage
            )
        )
    }
    
    public static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }
    
    /// Push a new environment onto the stack
    public static func pushEnvironment(_ env: Environment) {
        stack.append(env)
    }
    
    public static func pushEnvironment(
        apiService: ServiceProtocol = AppEnvironment.current.apiService
    ) {
        pushEnvironment(Environment(apiService: apiService))
    }
    
    @discardableResult
    public static func popEnvironment() -> Environment? {
        return stack.popLast()
    }
}

