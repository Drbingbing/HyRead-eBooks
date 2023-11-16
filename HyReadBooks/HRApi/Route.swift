//
//  Route.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation

internal enum Route {
    case userList
    
    internal var requestProperties: (method: Method, path: String) {
        switch self {
        case .userList:
            return (.GET, "/exam/user-list")
        }
    }
}
