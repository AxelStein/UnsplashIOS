//
//  BaseInteractor.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation

class BaseInteractor<T: Codable> {
    private let decoder: JSONDecoder
    private var task: URLSessionDataTask? = nil
    
    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func launch(urlRequest: URLRequest, handler: @escaping (Result<T, Error>) -> Void) {
        task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            self.task = nil
            if let data = data {
                do {
                    let result = try self.decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        handler(.success(result))
                    }
                } catch let err {
                    DispatchQueue.main.async {
                        handler(.failure(err))
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
            }
        }
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}
