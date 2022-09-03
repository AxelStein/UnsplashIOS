//
//  Photo.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation

struct Photo: Codable {
    let id: String
    let urls: [String: String]
}

struct SearchResults: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
}

struct SearchRequest {
    let query: String
    var page: Int = 1
    var perPage: Int = 10
}
