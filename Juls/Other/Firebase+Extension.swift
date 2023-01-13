//
//  Firebase+Extension.swift
//  Juls
//
//  Created by Fanil_Jr on 06.01.2023.
//

import Foundation
import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { error in
            print("Failet to fetch user", error)
        }
    }
//    func fetchPostsWithUser(user: User) {
//        
//        let ref = Database.database().reference().child("posts").child(user.uid)
//        
//        ref.queryOrdered(byChild: "creationData").observe(.value, with: { snapshot in
//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            
//            dictionaries.forEach { key, value in
//                guard let dictionary = value as? [String: Any] else { return }
//                
//                let post = Post(user: user, dictionary: dictionary)
//                self.posts.insert(post, at: 0)
//            }
//            self.tableView.reloadData()
//        }) { error in
//            print("Failed to fetch posts:", error)
//        }
//    }
     
}
