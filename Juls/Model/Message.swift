//
//  Message.swift
//  Juls
//
//  Created by Fanil_Jr on 24.02.2023.
//

import Foundation

struct Message {
    
    var id: String?
    let user: User
    let text: String
    let uid: String
    let creationDate: Date
    var image: String
    var isRead: Bool
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["message"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.isRead = dictionary["isRead"] as? Bool ?? false
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
        self.image = dictionary["imageURL"] as? String ?? ""
    }    
}
