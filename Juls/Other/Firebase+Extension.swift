//
//  Firebase+Extension.swift
//  Juls
//
//  Created by Fanil_Jr on 06.01.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage


var messagesPerPage: Int = 25
var loadedMessagesCount: Int = 0

extension Database {
    
    //MARK: USER & USERS
    
    func fetchUser(withUID uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("Failed to fetch user from database:", err)
        }
    }
    
    func fetchUserForLoveBoys(completion: @escaping ([User]) -> ()) {
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            var users = [User]()
            userDictionary.forEach { key, value in
                if let userDict = value as? [String: Any],
                    let isActiveMath = userDict["isActiveMatch"] as? Bool,
                    isActiveMath == true,
                    let gender = userDict["sex"] as? String,
                    gender == "Female" {
                        // User has the key "isActiveMath" with a value of true and is a female, so include in the result
                    let user = User(uid: key, dictionary: userDict)
                    users.append(user)
                }
            }
            completion(users)
        })
    }
    
    func fetchUserForLoveGirls(completion: @escaping ([User]) -> ()) {
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            var users = [User]()
            userDictionary.forEach { key, value in
                if let userDict = value as? [String: Any],
                    let isActiveMath = userDict["isActiveMatch"] as? Bool,
                    isActiveMath == true,
                    let gender = userDict["sex"] as? String,
                    gender == "Male" {
                        // User has the key "isActiveMath" with a value of true and is a female, so include in the result
                    let user = User(uid: key, dictionary: userDict)
                    users.append(user)
                }
            }
            completion(users)
        })
    }
    
    func fetchRaitingUser(withUID uid: String, completion: @escaping (Raiting) -> ()) {
        Database.database().reference().child("rating").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let rating = Raiting(uid: uid, dictionary: userDictionary)
            completion(rating)
        }) { (err) in
            print("Failed to fetch user from database:", err)
        }
    }
    //MARK: Рабочий, но внизу измененный, но пока не уверен в измененном
//    func fetchAllUsersRating(includeCurrentUser: Bool = true, completion: @escaping ([User]) -> ()) {
//        let ref = Database.database().reference().child("users")
//        ref.observeSingleEvent(of: .value, with: { (snapshot) in
//            guard let dictionaries = snapshot.value as? [String: Any] else {
//                completion([])
//                return
//            }
//
//            var users = [User]()
//
//            dictionaries.forEach({ (key, value) in
//                if !includeCurrentUser, key == Auth.auth().currentUser?.uid {
//                    completion([])
//                    return
//                }
//                guard let userDictionary = value as? [String: Any] else { return }
//                let user = User(uid: key, dictionary: userDictionary)
//                users.append(user)
//            })
//            users.sort { $0.rating > $1.rating }
//            let topTenUsers = Array(users.prefix(10))
//            completion(topTenUsers)
//        })
//    }
    
    func fetchTopTenUsersRating(includeCurrentUser: Bool = true, completion: @escaping ([User]) -> ()) {
        let ref = Database.database().reference().child("users")
        ref.queryOrdered(byChild: "rating").queryLimited(toLast: 10).observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var users = [User]()
            
            dictionaries.forEach { (key, value) in
                if !includeCurrentUser, key == Auth.auth().currentUser?.uid {
                    completion([])
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                users.append(user)
            }
            users.sort { $0.rating > $1.rating }
            completion(users)
        })
    }

    
    func fetchAllUsers(includeCurrentUser: Bool = true, completion: @escaping ([User]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var users = [User]()
            
            dictionaries.forEach({ (key, value) in
                if !includeCurrentUser, key == Auth.auth().currentUser?.uid {
                    completion([])
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                users.append(user)
            })
            
            users.sort(by: { (user1, user2) -> Bool in
                return user1.username.compare(user2.username) == .orderedAscending
            })
            completion(users)
            
        }) { (err) in
            print("Failed to fetch all users from database:", (err))
            cancel?(err)
        }
    }
    
    //MARK: Проверка подписки на юзера и методы подписки
    
    func isFollowingUser(withUID uid: String, completion: @escaping (Bool) -> (), withCancel cancel: ((Error) -> ())?) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                completion(true)
            } else {
                completion(false)
            }
            
        }) { (err) in
            print("Failed to check if following:", err)
            cancel?(err)
        }
    }
    
    func followUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: 1]
        Database.database().reference().child("following").child(currentLoggedInUserId).updateChildValues(values) { (err, ref) in
            if let err = err {
                completion(err)
                return
            }
            
            let values = [currentLoggedInUserId: 1]
            Database.database().reference().child("followers").child(uid).updateChildValues(values) { (err, ref) in
                if let err = err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func unfollowUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).removeValue { (err, _) in
            if let err = err {
                print("Failed to remove user from following:", err)
                completion(err)
                return
            }
            
            Database.database().reference().child("followers").child(uid).child(currentLoggedInUserId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to remove user from followers:", err)
                    completion(err)
                    return
                }
                completion(nil)
            })
        }
    }
    
    //MARK: Посты и комментарии
    
    func fetchPost(withUID uid: String, postId: String, completion: @escaping (Post) -> (), withCancel cancel: ((Error) -> ())? = nil) {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid).child(postId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let postDictionary = snapshot.value as? [String: Any] else { return }
            
            Database.database().fetchUser(withUID: uid, completion: { (user) in
                var post = Post(user: user, dictionary: postDictionary)
                post.id = postId
                
                //check likes
                Database.database().reference().child("likes").child(postId).child(currentLoggedInUser).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.hasLiked = true
                    } else {
                        post.hasLiked = false
                    }
                    
                    Database.database().numberOfItemsForUser(withUID: postId, category: "likes", completion: { (count) in
                        post.likes = count
                        
                        Database.database().numberOfItemsForUser(withUID: postId, category: "comments") { count in
                            post.comments = count
                            completion(post)
                        }
                    })
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                    cancel?(err)
                })
            })
        })
    }
    
    func fetchAllPosts(withUID uid: String, completion: @escaping ([Post]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }

            var posts = [Post]()

            dictionaries.forEach({ (postId, value) in
                Database.database().fetchPost(withUID: uid, postId: postId, completion: { (post) in
                    posts.append(post)
                    
                    
                    if posts.count == dictionaries.count {
                        posts.sort { p1, p2 in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        }
                        completion(posts)
                    }
                })
            })
        }) { (err) in
            print("Failed to fetch posts:", err)
            cancel?(err)
        }
    }
    
    func createPost(withImage image: UIImage, caption: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }

        let maxResolutionImage: UIImage?
        if image.size.height > 3000 {
            maxResolutionImage = image.resize(to: CGSize(width: image.size.width / 4, height: image.size.height / 4))
        } else {
            maxResolutionImage = image.resize(to: CGSize(width: image.size.width / 3.5, height: image.size.height / 3.5))
        }
        guard let resolutionImage = maxResolutionImage else { return }
        
        Storage.storage().uploadPostImage(image: resolutionImage, filename: postId) { (postImageUrl) in
            let values = ["imageUrl": postImageUrl, "caption": caption, "imageWidth": resolutionImage.size.width, "imageHeight": resolutionImage.size.height, "creationDate": Date().timeIntervalSince1970, "id": postId] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func deletePost(withUID uid: String, postId: String, completion: ((Error?) -> ())? = nil) {
        Database.database().reference().child("posts").child(uid).child(postId).removeValue { (err, _) in
            if let err = err {
                print("Failed to delete post:", err)
                completion?(err)
                return
            }
            
            Database.database().reference().child("comments").child(postId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to delete comments on post:", err)
                    completion?(err)
                    return
                }
                
                Database.database().reference().child("likes").child(postId).removeValue(completionBlock: { (err, _) in
                    if let err = err {
                        print("Failed to delete likes on post:", err)
                        completion?(err)
                        return
                    }
                    
                    Storage.storage().reference().child("post_images").child(postId).delete(completion: { (err) in
                        if let err = err {
                            print("Failed to delete post image from storage:", err)
                            completion?(err)
                            return
                        }
                    })
                    
                    completion?(nil)
                })
            })
        }
    }
    
    func addCommentToPost(withId postId: String, text: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["text": text, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        
        let commentsRef = Database.database().reference().child("comments").child(postId).childByAutoId()
        commentsRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to add comment:", err)
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    func fetchCommentsForPost(withId postId: String, completion: @escaping ([Comment]) -> ()) {
        let commentsReference = Database.database().reference().child("comments").child(postId)
        
        commentsReference.observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var comments = [Comment]()
            
            dictionaries.forEach({ (key, value) in
                guard let commentDictionary = value as? [String: Any] else { return }
                guard let uid = commentDictionary["uid"] as? String else { return }
                
                Database.database().fetchUser(withUID: uid) { (user) in
                    let comment = Comment(user: user, dictionary: commentDictionary)
                    comments.append(comment)
                    
                    if comments.count == dictionaries.count {
                        comments.sort(by: { (comment1, comment2) -> Bool in
                            return comment1.creationDate.compare(comment2.creationDate) == .orderedAscending
                        })
                        completion(comments)
                    }
                }
            })
        })
    }
}

//MARK: Загрузки аватара и картинки поста

extension Storage {
    
    fileprivate func uploadUserProfileImage(image: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = image.jpegData(compressionQuality: 1) else { return } //changed from 0.3
        
        let storageRef = Storage.storage().reference().child("profile_images").child(NSUUID().uuidString)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for profile image:", err)
                    return
                }
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                completion(profileImageUrl)
            })
        })
    }
    
    fileprivate func uploadPostImage(image: UIImage, filename: String, completion: @escaping (String) -> ()) {
        guard let uploadData = image.jpegData(compressionQuality: 0.1) else { return } //changed from 0.5
        
        let storageRef = Storage.storage().reference().child("post_images").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for post image:", err)
                    return
                }
                guard let postImageUrl = downloadURL?.absoluteString else { return }
                completion(postImageUrl)
            })
        })
    }
    
    func uploadImageForMessage(image: UIImage, filename: String, completion: @escaping (String) -> ()) {
        guard let uploadData = image.jpegData(compressionQuality: 0.1) else { return } //changed from 0.5
        
        let storageRef = Storage.storage().reference().child("message_images").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for post image:", err)
                    return
                }
                guard let postImageUrl = downloadURL?.absoluteString else { return }
                completion(postImageUrl)
            })
        })
    }
    
    func uploadSongToFirebase(fileURL: URL) {
        let storageRef = Storage.storage().reference()
        let songRef = storageRef.child("songs/\(fileURL.lastPathComponent)")

        songRef.putFile(from: fileURL, metadata: nil) { (metadata, error) in
            if let error {
                print("Error uploading file: \(error.localizedDescription )")
                return
            }

            print("File uploaded successfully")

            songRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    print("Error getting download URL: \(error?.localizedDescription ?? "unknown error")")
                    return
                }

                print("Download URL: \(downloadURL)")

                // Now you can use the download URL to retrieve the file
                let session = URLSession.shared
                let downloadTask = session.downloadTask(with: downloadURL) { (url, response, error) in
                    if let error {
                        print("Error downloading file: \(error.localizedDescription)")
                        return
                    }
                    print("File downloaded successfully")
                    // Use the localURL to access the downloaded file
                }
                downloadTask.resume()
            }
        }
    }
}

//MARK: CHAT ~
extension Database {
    func pushMessageWithChatId(userUID uid: String, userFriendUID uidFriend: String, textMessage text: String, completion: @escaping (Error?) -> ()) {
            
        let valuesForMessages = ["message": text, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        let valuesForLastMessage = ["message": text, "creationDate": Date().timeIntervalSince1970, "uid": uid, "isRead": false] as [String: Any]
            
        let lastMessageRef = Database.database().reference().child("lastMessage")
        let messageRef = Database.database().reference().child("messages")
            
        let group = DispatchGroup()
        var error: Error?
            
        group.enter()
        lastMessageRef.child(uid).child(uidFriend).updateChildValues(valuesForLastMessage) { err, _ in
            error = err
            group.leave()
        }
            
        group.enter()
        lastMessageRef.child(uidFriend).child(uid).updateChildValues(valuesForLastMessage) { err, _ in
            error = error ?? err
            group.leave()
        }
            
        group.enter()
        messageRef.child(uid).child(uidFriend).childByAutoId().updateChildValues(valuesForMessages) { err, _ in
            error = error ?? err
            group.leave()
        }
            
        group.enter()
        messageRef.child(uidFriend).child(uid).childByAutoId().updateChildValues(valuesForMessages) { err, _ in
            error = error ?? err
            group.leave()
        }
            
        group.notify(queue: .main) {
            completion(error)
        }
    }

    
    func fetchMessageWithChatId(userUID uid: String, userFriendUID uidFriend: String, completion: @escaping ([Message]) -> ()) {
        let commentsReference = Database.database().reference().child("messages").child(uid).child(uidFriend)
        let query = commentsReference.queryOrderedByKey().queryLimited(toLast: UInt(messagesPerPage))
        query.observe(.value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            var messages = [Message]()
            dictionaries.forEach({ (key, value) in
                guard let messageCitionary = value as? [String: Any] else { return }
                guard let uid = messageCitionary["uid"] as? String else { return }
                Database.database().fetchUser(withUID: uid) { (user) in
                    let message = Message(user: user, dictionary: messageCitionary)
                    messages.append(message)
                    if messages.count == dictionaries.count {
                        messages.sort(by: { (message1, message2) -> Bool in
                            return message1.creationDate.compare(message2.creationDate) == .orderedAscending
                        })
                        completion(messages)
                    }
                }
            })
        })
    }
    //MARK: второй вариант
    func fetchMessages(userUID uid: String, userFriendUID uidFriend: String, completion: @escaping ([Message]) -> ()) {
            
        let commentsReference = Database.database().reference().child("messages").child(uid).child(uidFriend)
        let query = commentsReference.queryOrderedByKey().queryLimited(toLast: UInt(messagesPerPage + loadedMessagesCount))
        
        query.observe(.value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var messages = [Message]()
            
            dictionaries.forEach({ (key, value) in
                guard let messageCitionary = value as? [String: Any] else { return }
                guard let uid = messageCitionary["uid"] as? String else { return }
                
                Database.database().fetchUser(withUID: uid) { (user) in
                    let message = Message(user: user, dictionary: messageCitionary)
                    messages.append(message)
                    
                    if messages.count == dictionaries.count {
                        messages.sort(by: { (message1, message2) -> Bool in
                            return message1.creationDate.compare(message2.creationDate) == .orderedAscending
                        })
                        loadedMessagesCount = messages.count
                        completion(messages)
                    }
                }
            })
        })
    }

    func feetchUsersForSearch(completion: @escaping ([User]) -> ()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            var users = [User]()
            
            dictionaries.forEach { key, value in
                if key == uid {
                    return
                }
                guard let userDictionary = value as? [String: Any] else { return }
                
                let user = User(uid: key, dictionary: userDictionary)
                users.append(user)
            }
            completion(users)
        })
    }
    
    func getUsersIFollow(myUserId userId: String, completion: @escaping ([User]) ->()) {
        let ref = Database.database().reference().child("following").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            var myUsers = [User]()
            
            dictionaries.forEach { key, value in
                Database.database().fetchUser(withUID: key) { users in
                    myUsers.append(users)
                    completion(myUsers)
                }
            }
        })
    }
    
    func getUsersFollowMe(myUserId userId: String, completion: @escaping ([User]) ->()) {
        let ref = Database.database().reference().child("followers").child(userId)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            var myUsers = [User]()
            
            dictionaries.forEach { key, value in
                Database.database().fetchUser(withUID: key) { users in
                    myUsers.append(users)
                    completion(myUsers)
                }
            }
        })
    }
    
    func getFollowersAndFollowingUsers(myUserId userId: String, completion: @escaping ([User], [User]) ->()) {
        let followingRef = Database.database().reference().child("following").child(userId)
        let followersRef = Database.database().reference().child("followers").child(userId)

        var followingUsers = [User]()
        var followersUsers = [User]()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        followingRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let followingDictionaries = snapshot.value as? [String: Any] else {
                dispatchGroup.leave()
                return
            }
            followingDictionaries.forEach { key, value in
                dispatchGroup.enter()
                Database.database().fetchUser(withUID: key) { user in
                    followingUsers.append(user)
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.leave()
        })

        dispatchGroup.enter()
        followersRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let followersDictionaries = snapshot.value as? [String: Any] else {
                dispatchGroup.leave()
                return
            }
            followersDictionaries.forEach { key, value in
                dispatchGroup.enter()
                Database.database().fetchUser(withUID: key) { user in
                    followersUsers.append(user)
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.leave()
        })

        dispatchGroup.notify(queue: .main) {
            completion(followingUsers, followersUsers)
        }
    }

    
    func changeIsRead(friendUserId friendId: String, friendRead read: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("lastMessage").child(uid).child(friendId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach({ (key, value) in
                Database.database().reference().child("lastMessage").child(uid).child(friendId).updateChildValues(["isRead" : read]) { error, ref in
                    if let error {
                        print(error)
                        return
                    }
                }
            })
        })
    }
    
    func checkNewMessage(userUid uid: String, completion: @escaping (Int) -> ()) {
        let ref = Database.database().reference().child("lastMessage").child(uid)
        ref.observe(.value, with: { snapshot in
            
            var massive = [Bool]()
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            dictionary.forEach { key, value in
                guard let message = value as? [String: Any] else { return }
                message.forEach { key,value in
                    guard let read = value as? Bool else { return }
                    if read == false {
                        massive.append(read)
                    }
                }
            }
            completion(massive.count)
        })
    }
    
    func updateMessageInNavigationBar(userId: String, navigation: UINavigationController,label: UILabel) {
        Database.database().checkNewMessage(userUid: userId) { count in
            if userId == Auth.auth().currentUser?.uid {
                navigation.navigationBar.addSubview(label)
                if count == 0 {
                    DispatchQueue.main.async {
                        label.text = ""
                        print("no new messages")
                    }
                } else {
                    DispatchQueue.main.async {
                        label.text = "\(count)"
                        print("you have \(count) message(s)")
                    }
                }
            }
        }
    }

    
    func checkIsRead(friendUserId friendId: String, completion: @escaping (Bool) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("lastMessage").child(friendId).child(uid)
        ref.observe(.value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { key, value in
                guard let readMessage = value as? Bool else { return }
                completion(readMessage)
            }
        })
    }
    
    func getLastMessage(friendUserId friendId: String, completion: @escaping (String) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("lastMessage").child(friendId).child(uid)
        ref.observe(.value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach { key, value in
                guard let message = value as? String else { return }
                if message == uid {
                    return
                }
                completion(message)
            }
        })
    }
    
    func fetchAllLastMessages(userUID uid: String, completion: @escaping ([User]) -> ()) {
        let ref = Database.database().reference().child("lastMessage").child(uid)
        ref.observe(.value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            var users = [User]()
            
            dictionaries.forEach { key, value in
                Database.database().fetchUser(withUID: key) { user in
                    users.append(user)
                    users.sort(by: { (message1, message2) -> Bool in
                        return message2.creationDateLastMessage.compare(message1.creationDateLastMessage) == .orderedAscending
                    })
                    completion(users)
                }
            }
        })
    }
    
    func fetchLastMessagesInMessenger(userUID uid: String, completion: @escaping ([Message]) -> ()) {
        let ref = Database.database().reference().child("lastMessage").child(uid)
        ref.observe(.value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            var messages = [Message]()
            
            dictionaries.forEach({ (key, value) in
                guard let messageCitionary = value as? [String: Any] else { return }
                
                
                Database.database().fetchUser(withUID: key) { (user) in
                    let message = Message(user: user, dictionary: messageCitionary)
                    messages.append(message)
                    
                    if messages.count == dictionaries.count {
                        messages.sort(by: { (message1, message2) -> Bool in
                            return message2.creationDate.compare(message1.creationDate) == .orderedAscending
                        })
                        completion(messages)
                    }
                }
            })
        })
    }
    
    func removeChatWithAllChats(userUID uid: String, userFriendWithDeleteUID uidFriend: String, completion: ((Error?) -> ())? = nil) {
        Database.database().reference().child("messages").child(uid).child(uidFriend).removeValue() { (err, _) in
            if let err = err {
                print("Failed to delete chat:", err)
                completion?(err)
                return
            }
            Database.database().reference().child("messages").child(uidFriend).child(uid).removeValue() { (err, _) in
                if let err = err {
                    print("Failed to delete chat:", err)
                    completion?(err)
                    return
                }
                Database.database().reference().child("lastMessage").child(uid).child(uidFriend).removeValue() { (err, _) in
                    if let err = err {
                        print("Failed to delete chat:", err)
                        completion?(err)
                        return
                    }
                    Database.database().reference().child("lastMessage").child(uidFriend).child(uid).removeValue() { (err, _) in
                        if let err = err {
                            print("Failed to delete chat:", err)
                            completion?(err)
                            return
                        }
                        completion?(nil)
                    }
                }
            }
        }
    }
    
    //MARK: version ChatGPT
    func fetchFeedPosts(completion: @escaping ([Post]) -> Void) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }

        var userIdsToFetchPostsFrom = [currentLoggedInUserId]

        Database.database().reference().child("following").child(currentLoggedInUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }

            userIdsToFetchPostsFrom += userIdsDictionary.keys

            DispatchQueue.global(qos: .background).async {
                let fetchGroup = DispatchGroup()

                var posts = [Post]()

                for uid in userIdsToFetchPostsFrom {
                    fetchGroup.enter()

                    Database.database().fetchAllPosts(withUID: uid, completion: { (postsForUser) in
                        posts += postsForUser
                        fetchGroup.leave()
                    }, withCancel: { (err) in
                        fetchGroup.leave()
                    })
                }

                fetchGroup.notify(queue: .main) {
                    let sortedPosts = posts.sorted { $0.creationDate > $1.creationDate }
                    completion(sortedPosts)
                }
            }
        }) { (err) in
            print(err)
        }
    }
    
    func numberOfItemsForUser(withUID uid: String, category: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child(category).child(uid).observe(.value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func listeForUserStatusChanges(userid: String, completion: @escaping (_ isOnline: Bool) -> ()) {
        Database.database().reference().child("users").child(userid).observe(.value, with: { snapshot in
            if let status = snapshot.value as? String {
                completion(status == "online")
            } else {
                completion(false)
            }
        })
    }
    
    //MARK: RAITING
    
    func addCommentForUserRaiting(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: true]
        Database.database().reference().child("sendCommentsForRaiting").child(currentLoggedInUserId).updateChildValues(values) { (err, _) in
            if let err {
                completion(err)
                return
            }
            let values = [currentLoggedInUserId: true]
            Database.database().reference().child("getCommentsForRaiting").child(uid).updateChildValues(values) { (err, _) in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func fetchCommentsForRaiting(withUID uid: String, completion: @escaping (Bool) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("sendCommentsForRaiting").child(currentLoggedInUserId).child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snap = snapshot.value as? Bool else { return }
            if snap == true {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func addMessageForUserRaiting(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: true]
        Database.database().reference().child("sendMessagesForRaiting").child(currentLoggedInUserId).updateChildValues(values) { (err, _) in
            if let err {
                completion(err)
                return
            }
            let values = [currentLoggedInUserId: true]
            Database.database().reference().child("getMessagesForRaiting").child(uid).updateChildValues(values) { (err, _) in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func fetchMessagesForRaiting(withUID uid: String, completion: @escaping (Bool) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("sendMessagesForRaiting").child(currentLoggedInUserId).child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snap = snapshot.value as? Bool else { return }
            if snap == true {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func addLikeForUserRaiting(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: true]
        Database.database().reference().child("sendLikeForRaiting").child(currentLoggedInUserId).updateChildValues(values) { (err, _) in
            if let err {
                completion(err)
                return
            }
            let values = [currentLoggedInUserId: true]
            Database.database().reference().child("getLikeForRaiting").child(uid).updateChildValues(values) { (err, _) in
                if let err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func fetchLikeForRaiting(withUID uid: String, completion: @escaping (Bool) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("sendLikeForRaiting").child(currentLoggedInUserId).child(uid)
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let snap = snapshot.value as? Bool else { return }
            if snap == true {
                completion(true)
            } else {
                completion(false)
            }
        })
    }
    
    func likeUserAcc(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        let values = [uid: 1]
        Database.database().reference().child("YoulikeAcc").child(currentLoggedInUserId).updateChildValues(values) { (err, ref) in
            if let err = err {
                completion(err)
                return
            }
            let values = [currentLoggedInUserId: 1]
            Database.database().reference().child("likeYourAcc").child(uid).updateChildValues(values) { (err, ref) in
                if let err = err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func unLikeUserAcc(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("YoulikeAcc").child(currentLoggedInUserId).child(uid).removeValue { (err, _) in
            if let err = err {
                print("Failed to remove user from following:", err)
                completion(err)
                return
            }
            Database.database().reference().child("likeYourAcc").child(uid).child(currentLoggedInUserId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to remove user from followers:", err)
                    completion(err)
                    return
                }
                completion(nil)
            })
        }
    }
}
