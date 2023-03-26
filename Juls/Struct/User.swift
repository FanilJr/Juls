//
//  User.swift
//  Juls
//
//  Created by Fanil_Jr on 05.01.2023.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let picture: String
    let status: String
    let name: String
    let secondName: String
    let age: String
    let lifeStatus: String
    let height: String
    var official: Bool
    let creationDateLastMessage: Date
    let loveSong: String
    let isActiveMatch: Bool
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.official = dictionary["official"] as? Bool ?? false
        self.picture = dictionary["picture"] as? String ?? ""
        self.status = dictionary["status"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.secondName = dictionary["secondName"] as? String ?? ""
        self.age = dictionary["age"] as? String ?? ""
        self.lifeStatus = dictionary["life status"] as? String ?? ""
        self.height = dictionary["height"] as? String ?? ""
        self.loveSong = dictionary["loveSong"] as? String ?? ""
        self.isActiveMatch = dictionary["isActiveMatch"] as? Bool ?? false
        
        let secondsFrom1970 = dictionary["creationDateLastMessage"] as? Double ?? 0
        self.creationDateLastMessage = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
