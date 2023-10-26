//
//  Raiting.swift
//  Juls
//
//  Created by Fanil_Jr on 29.03.2023.
//

import Foundation

struct Raiting {
    let uid: String
    let rating: Double
    let commentsRating: Double
    let postsRating: Double
    let likeYouUserAcc: Double
    let likeYourAcc: Double
    let getCommentsRating: Double
    let followersRating: Double
    let playGameCount: Double
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.rating = dictionary["rating"] as? Double ?? 0.0
        self.commentsRating = dictionary["commentsRating"] as? Double ?? 0.0
        self.postsRating = dictionary["postsRating"] as? Double ?? 0.0
        self.likeYouUserAcc = dictionary["likeYouUserAcc"] as? Double ?? 0.0
        self.likeYourAcc = dictionary["likeYourAcc"] as? Double ?? 0.0
        self.getCommentsRating = dictionary["getComments"] as? Double ?? 0.0
        self.followersRating = dictionary["followersRating"] as? Double ?? 0.0
        self.playGameCount = dictionary["playGameCount"] as? Double ?? 0.0
    }
}
