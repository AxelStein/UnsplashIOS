//
//  Endpoint.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation

class Endpoint {
    private let scheme = "https"
    private let host = "api.unsplash.com"
    private var path = ""
    private var queryItems = [URLQueryItem]()
    
    init(path: String) {
        self.path = path
    }
    
    func addQuery(_ name: String, _ value: String) {
        queryItems.append(
            URLQueryItem(name: name, value: value)
        )
    }
    
    func addQuery(_ name: String, _ value: Int) {
        queryItems.append(
            URLQueryItem(name: name, value: String(value))
        )
    }
    
    static func searchPhotos(_ request: SearchRequest) -> URLRequest {
        let endpoint = Endpoint(path: "/search/photos")
        endpoint.addQuery("query", request.query)
        endpoint.addQuery("page", request.page)
        endpoint.addQuery("per_page", request.perPage)
        return endpoint.urlRequest
    }
}

extension Endpoint {
    var urlRequest: URLRequest {
        var components = URLComponents()
        components.host = self.host
        components.scheme = self.scheme
        components.path = self.path
        components.queryItems = self.queryItems
        
        var request = URLRequest(url: components.url!)
        request.setValue("Authorization: Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        return request
    }
}
