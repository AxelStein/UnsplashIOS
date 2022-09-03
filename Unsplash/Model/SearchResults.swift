//
//  SearchResults.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation

struct SearchResults: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
}
