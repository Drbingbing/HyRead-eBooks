//
//  MyBook.swift
//  HyReadBooks
//
//  Created by 鍾秉辰 on 2023/11/17.
//

import Foundation
import HRLibrary
import HRApi

struct MyBook: Hashable {
    
    var uuid: Int
    var title: String
    var coverURL: String
    var publishDate: String
    var publisher: String
    var author: String
    var saved: Bool
    
    init(uuid: Int, title: String, coverURL: String, publishDate: String, publisher: String, author: String, saved: Bool) {
        self.uuid = uuid
        self.title = title
        self.coverURL = coverURL
        self.publishDate = publishDate
        self.publisher = publisher
        self.author = author
        self.saved = saved
    }
}

extension Book {
    
    func asMyBook() -> MyBook {
        MyBook(
            uuid: uuid,
            title: title,
            coverURL: coverURL, 
            publishDate: publishDate,
            publisher: publisher,
            author: author,
            saved: false
        )
    }
}
