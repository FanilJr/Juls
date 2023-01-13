//
//  Post.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let message: String
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.message = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
