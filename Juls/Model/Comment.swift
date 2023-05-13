//
//  Comment.swift
//  Juls
//
//  Created by Fanil_Jr on 11.02.2023.
//

import Foundation

class Comment {
    
    var id: String?
    let user: User
    let text: String
    let uid: String
    let creationDate: Date
    
    init(user: User, dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.user = user
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
    deinit {
        print("class Comment", text, "deinit")
    }
}
