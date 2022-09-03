//
//  SearchRequest.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation

struct SearchRequest {
    let query: String
    var page: Int = 1
    var perPage: Int = 30
}
