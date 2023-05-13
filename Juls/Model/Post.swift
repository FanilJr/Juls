//
//  Post.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation

class Post {
    
    var id: String?
    let user: User
    let imageUrl: String
    let message: String
    let creationDate: Date
    var hasLiked = true
    
    var likes: Int = 0
    var comments: Int = 0
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.message = dictionary["caption"] as? String ?? ""
        
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    deinit {
        print("class Post", message, "deinit")
    }
}

