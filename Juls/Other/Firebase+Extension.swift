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
}
