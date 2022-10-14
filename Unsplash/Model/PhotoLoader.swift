//
//  PhotoLoader.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation
import UIKit

let photoLoader = PhotoLoader()

class PhotoLoader {
    private let cache = NSCache<AnyObject, AnyObject>()
    private var tasks = [URL: URLSessionDataTask]()
    
    func load(url: URL, photo: Photo, completion: @escaping (Photo, UIImage?) -> Void) {
        if let cached = cache.object(forKey: url as AnyObject) as? UIImage {
            tasks.removeValue(forKey: url)
            completion(photo, cached)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, res, err in
            DispatchQueue.main.async {
                self.tasks.removeValue(forKey: url)
            }
            guard let data = data,
                  let image = UIImage(data: data),
                  err == nil else {
                DispatchQueue.main.async {
                    completion(photo, nil)
                }
                return
            }
            
            self.cache.setObject(image, forKey: url as AnyObject, cost: data.count)
            
            DispatchQueue.main.async {
                completion(photo, image)
            }
        }
        tasks[url] = task
        task.resume()
    }
    
    func cancel(for url: URL) {
        if let task = tasks[url] {
            task.cancel()
            tasks.removeValue(forKey: url)
        }
    }
}
