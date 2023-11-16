//
//  ErrorEnvelope.swift
//  HRApi
//
//  Created by BingBing on 2023/11/16.
//

import Foundation

public struct ErrorEnvelope {
    public let errorMessages: [String]
    public let hrCode: HRCode?
    public let httpCode: Int
    
    public init(errorMessages: [String] = [], hrCode: HRCode? = .APIError, httpCode: Int = 400) {
        self.errorMessages = errorMessages
        self.hrCode = hrCode
        self.httpCode = httpCode
    }
    
    public enum HRCode: String {
        
        // Codes defined by the client
        
        case JSONParsingFailed = "json_parsing_failed"
        case ErrorEnvelopeJSONParsingFailed = "error_json_parsing_failed"
        case APIError = "api_error"
        case DecodingJSONFailed = "decoding_json_failed"
    }
}

extension ErrorEnvelope: Error {}

extension ErrorEnvelope {
    
    /// A general error that some JSON could not be decoded.
    ///
    /// - parameter decodeError: The JSONDecoder decoding error.
    ///
    /// - returns: An error envelope that describes why decoding failed.
    internal static func couldNotDecodeJSON(_ decodeError: Error) -> ErrorEnvelope {
        return ErrorEnvelope(
            errorMessages: [decodeError.localizedDescription],
            hrCode: .DecodingJSONFailed,
            httpCode: 400
        )
    }
    
    /// A general error that JSON could not be parsed.
    internal static let couldNotParseJSON = ErrorEnvelope(
        errorMessages: [],
        hrCode: .JSONParsingFailed,
        httpCode: 400
    )
    
    internal static func hrAPIError(_ message: String) -> ErrorEnvelope {
        return ErrorEnvelope(
            errorMessages: [message],
            hrCode: .APIError,
            httpCode: 200
        )
    }
}

extension ErrorEnvelope {
    
    static func parse(from jsonData: [String: Any]) -> ErrorEnvelope {
        let errorMessage = jsonData["status_message"] as? String ?? ""
        let statusCode = jsonData["status_code"] as? Int ?? 400
        return ErrorEnvelope(errorMessages: [errorMessage], hrCode: .APIError, httpCode: statusCode)
    }
}
