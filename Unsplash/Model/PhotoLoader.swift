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
    // private var loadingResponses = [URL: [(Photo, UIImage?) -> Void]]()
    
    func load(url: URL, photo: Photo, completion: @escaping (Photo, UIImage?) -> Void) {
        if let cached = cache.object(forKey: url as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                completion(photo, cached)
            }
            return
        }
        /*
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
        } else {
            loadingResponses[url] = [completion]
        }
        */
        
        URLSession.shared.dataTask(with: url) { data, res, err in
            guard let data = data,
                  let image = UIImage(data: data),
                  // let blocks = self.loadingResponses[url],
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
            /*
            for block in blocks {
                DispatchQueue.main.async {
                    block(photo, image)
                }
                return
            }
            */
        }.resume()
    }
}
