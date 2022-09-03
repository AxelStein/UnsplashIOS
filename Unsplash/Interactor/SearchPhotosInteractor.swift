//
//  SearchPhotosInteractor.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation

class SearchPhotosInteractor : BaseInteractor<SearchResults> {
    
    func invoke(_ request: SearchRequest, handler: @escaping (Result<SearchResults, Error>) -> Void) {
        launch(urlRequest: Endpoint.searchPhotos(request), handler: handler)
    }
}
