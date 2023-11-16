//
//  Book.swift
//  HRApi
//
//  Created by Bing Bing on 2023/11/16.
//

import Foundation

public struct Book: Decodable {
    
    public var title: String
    public var uuid: Int
    public var coverURL: String
    public var publishDate: String
    public var publisher: String
    public var author: String
    
    public init(uuid: Int, title: String, coverURL: String, publishDate: String, publisher: String, author: String) {
        self.uuid = uuid
        self.title = title
        self.coverURL = coverURL
        self.publishDate = publishDate
        self.publisher = publisher
        self.author = author
    }
    
    private enum CodingKeys: String, CodingKey {
        case uuid, title, publishDate, publisher, author
        case coverURL = "coverUrl"
    }
}
