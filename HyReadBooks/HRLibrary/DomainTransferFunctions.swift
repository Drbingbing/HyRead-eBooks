//
//  DomainTransferFunctions.swift
//  HRLibrary
//
//  Created by Bing Bing on 2023/11/19.
//

import Foundation
import HRLocalStorage
import HRApi

internal func asBook(_ cdBook: CDBook) -> Book {
    Book(
        uuid: Int(cdBook.uuid),
        title: cdBook.title ?? "",
        coverURL: cdBook.coverURL ?? "",
        publishDate: cdBook.publishDate ?? "",
        publisher: cdBook.publisher ?? "",
        author: cdBook.author ?? ""
    )
}
