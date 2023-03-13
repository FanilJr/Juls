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
    
    var isRead: Bool
    
    init(user: User, dictionary: [String: Any]) {
        self.text = dictionary["message"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.isRead = dictionary["isRead"] as? Bool ?? false
        self.user = user
        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
