//
//  User.swift
//  Unsplash
//
//  Created by Александр Шерий on 03.09.2022.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let profileImage: [String: String]
}

extension User {
    var photoUrl: URL? {
        if let str = profileImage["small"] {
            return URL(string: str)
        }
        return nil
    }
}
