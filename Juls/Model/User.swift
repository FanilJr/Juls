//
//  User.swift
//  Juls
//
//  Created by Fanil_Jr on 05.01.2023.
//

import Foundation

struct User {
    let uid: String
    let sex: String
    let username: String
    let picture: String
    let status: String
    let name: String
    let secondName: String
    let age: Int
    let lifeStatus: String
    var official: Bool
    let creationDateLastMessage: Date
    let loveSong: String
    let isActiveMatch: Bool
    let rating: Double
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.sex = dictionary["sex"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.official = dictionary["official"] as? Bool ?? false
        self.picture = dictionary["picture"] as? String ?? ""
        self.status = dictionary["status"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.secondName = dictionary["secondName"] as? String ?? ""
        self.age = dictionary["age"] as? Int ?? 0
        self.lifeStatus = dictionary["life status"] as? String ?? ""
        self.loveSong = dictionary["loveSong"] as? String ?? ""
        self.isActiveMatch = dictionary["isActiveMatch"] as? Bool ?? false
        self.rating = dictionary["rating"] as? Double ?? 0.0
        
        let secondsFrom1970 = dictionary["creationDateLastMessage"] as? Double ?? 0
        self.creationDateLastMessage = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
