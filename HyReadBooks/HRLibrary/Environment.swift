//
//  Environment.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation
import HRApi
import HRLocalStorage

///  A collection of **all** global variables and singletons that the app wants access to.
public struct Environment {
    
    /// A type that exposes endpoint for fetching HyRead-eBooks.
    public let apiService: ServiceProtocol
    
    /// A type that save data on local platform
    public let localStorage: LocalStorageProtocol
    
    public init(
        apiService: ServiceProtocol = HRService(),
        localStorage: LocalStorageProtocol = HRLocalStorage()
    ) {
        self.apiService = apiService
        self.localStorage = localStorage
    }
}
