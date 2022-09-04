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
    let likes: Int
    let description: String?
    let user: User
    let createdAt: Date
}

extension Photo {
    var smallPhotoURL: URL? {
        if let str = urls["small"] {
            return URL(string: str)
        }
        return nil
    }
    
    var thumbPhotoURL: URL? {
        if let str = urls["thumb"] {
            return URL(string: str)
        }
        return nil
    }
    
    var regularPhotoURL: URL? {
        if let str = urls["regular"] {
            return URL(string: str)
        }
        return nil
    }
}
