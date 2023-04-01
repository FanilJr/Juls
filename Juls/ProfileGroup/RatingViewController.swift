//
//  RatingViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 27.03.2023.
//

import Foundation
import UIKit
import Firebase

class RatingViewController: UIViewController {
    
    var rating: Raiting? {
        didSet {
            guard let commentsRating = rating?.commentsRating else { return }
            guard let postsRating = rating?.postsRating else { return }
            guard let likeYouUserAcc = rating?.likeYouUserAcc else { return }
            guard let messageRating = rating?.messagesRating else { return }
            guard let getCommentsRating = rating?.getCommentsRating else { return }
            guard let getMessagesRating = rating?.getMessagesRating else { return }
            guard let followersRating = rating?.followersRating else { return }
            guard let likeYourAcc = rating?.likeYourAcc else { return }
            guard let playGameCount = rating?.playGameCount else { return }
            
            progressComments.progress = Float(commentsRating)
            progressPostsRating.progress = Float(postsRating)
            progressLikeYouUserAcc.progress = Float(likeYouUserAcc)
            progressMessages.progress = Float(messageRating)
            progressGetComments.progress = Float(getCommentsRating)
            progressGetMessages.progress = Float(getMessagesRating)
            progressFollowers.progress = Float(followersRating)
            progressLikeYourAcc.progress = Float(likeYourAcc)
            progressPlayGameCount.progress = Float(playGameCount)
            
            self.commentCount.text = "\(Int(progressComments.progress * 100))/100"
            self.messageCount.text = "\(Int(progressMessages.progress * 10))/10"
            self.likeUserCount.text = "\(Int(progressLikeYouUserAcc.progress * 100))/100"
            self.getCommentCount.text = "\(Int(progressGetComments.progress * 100))/100"
            self.getMessageCount.text = "\(Int(progressGetMessages.progress * 10))/10"
            self.getYourLikeeCount.text = "\(Int(progressLikeYourAcc.progress * 100))/100"
            self.followersCount.text = "\(Int(progressFollowers.progress * 100))/100"
            self.postsCount.text = "\(Int(progressPostsRating.progress * 10 * 2))/20"
            self.gameCount.text = "\(Int(progressPlayGameCount.progress * 10))/5"
            
            [progressComments,progressPostsRating,progressLikeYouUserAcc,progressMessages,progressGetComments,progressGetMessages,progressFollowers,progressLikeYourAcc,progressPlayGameCount].forEach { progress in
                if progress.progress == 1 {
                    progress.progressTintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                }
            }
            
            let value = progressPostsRating.progress + progressComments.progress + progressLikeYouUserAcc.progress + progressMessages.progress + progressGetComments.progress + progressGetMessages.progress + progressFollowers.progress + progressLikeYourAcc.progress + progressPlayGameCount.progress
            
            let str = String(format: "%.3f", value)
            let result: Double = Double(str)!
            
            switch value {
            case 0.0:
                imageRating.image = UIImage(named: "1f4a9")
            case 1.0...1.99:
                imageRating.image = UIImage(named: "1fae0")
            case 2.0...2.99:
                imageRating.image = UIImage(named: "1f635-1f4ab")
            case 3.0...3.99:
                imageRating.image = UIImage(named: "1f972")
            case 4.0...4.99:
                imageRating.image = UIImage(named: "1f979")
            case 5.0...5.99:
                imageRating.image = UIImage(named: "1f642")
            case 6.0...6.99:
                imageRating.image = UIImage(named: "1f607")
            case 7.0...7.99:
                imageRating.image = UIImage(named: "1f60e")
            case 8.0...8.99:
                imageRating.image = UIImage(named: "1f525")
            case 9.0...10.0:
                imageRating.image = UIImage(named: "1f929")
            default:
                imageRating.image = UIImage(named: "1f4a9")
            }
            self.raitingLabel.text = "Рейтинг - \(result)"
            
            guard let userId = rating?.uid else { return }
            
            Database.database().reference().child("rating").child(userId).updateChildValues(["rating": result]) { error, _ in
                if let error {
                    print(error)
                    return
                }
                print("succes download rating in Firebase Library")
            }
        }
    }
    
    private let progressComments: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressPostsRating: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressLikeYouUserAcc: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressLikeYourAcc: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressMessages: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressGetComments: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressGetMessages: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressFollowers: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let progressPlayGameCount: UIProgressView = {
        let progress = UIProgressView()
        progress.setProgress(0, animated: false)
        progress.translatesAutoresizingMaskIntoConstraints = false
        return progress
    }()
    
    private let raitingLabel: UILabel = {
        let i = UILabel()
        i.text = "Рейтинг - 0.0"
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 30)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let commentsLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Комментарии"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let postsLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Посты"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let likedUserProfileLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Симпатии"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let likedYourUserLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Получено симпатий"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let likesOfPosts: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Лайки"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let timeInAppLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Время в сети"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let messagesOfUser: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Сообщения"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let getCommentsLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Получено комментариев"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let getMessagesLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Получено сообщений"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let followersLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Подписчики"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let playGameCountLabel: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.text = "Участие в игре"
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 15)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let commentCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let messageCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let likeUserCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let getCommentCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let getMessageCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let getYourLikeeCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let followersCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let postsCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    private let gameCount: UILabel = {
        let i = UILabel()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.textColor = UIColor.createColor(light: .black, dark: .white)
        i.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        i.font = UIFont(name: "Futura-Bold", size: 10)
        i.shadowOffset = CGSize(width: 1, height: 1)
        i.alpha = 1
        i.clipsToBounds = true
        return i
    }()
    
    var imageRating: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupLayout()
    }
    
    func setupLayout() {
        [raitingLabel,imageRating,commentsLabel,commentCount,messagesOfUser,messageCount,likedUserProfileLabel,likeUserCount,getCommentsLabel,getCommentCount,likedYourUserLabel,getYourLikeeCount,getMessagesLabel,getMessageCount,followersLabel,followersCount,postsLabel,postsCount,playGameCountLabel,gameCount].forEach { view.addSubview($0) }
        
        [progressComments,progressMessages,progressLikeYouUserAcc,progressGetComments,progressGetMessages,progressFollowers,progressLikeYourAcc,progressPostsRating,progressPlayGameCount].forEach { view.addSubview($0) }
        NSLayoutConstraint.activate([
            raitingLabel.topAnchor.constraint(equalTo: view.topAnchor,constant: 30),
            raitingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            imageRating.centerYAnchor.constraint(equalTo: raitingLabel.centerYAnchor),
            imageRating.leadingAnchor.constraint(equalTo: raitingLabel.trailingAnchor,constant: 20),
            imageRating.heightAnchor.constraint(equalToConstant: 50),
            imageRating.widthAnchor.constraint(equalToConstant: 50),
            
            commentsLabel.topAnchor.constraint(equalTo: raitingLabel.bottomAnchor,constant: 40),
            commentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressComments.centerYAnchor.constraint(equalTo: commentsLabel.centerYAnchor),
            progressComments.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressComments.widthAnchor.constraint(equalToConstant: 100),
            commentCount.trailingAnchor.constraint(equalTo: progressComments.leadingAnchor,constant: -5),
            commentCount.centerYAnchor.constraint(equalTo: progressComments.centerYAnchor),
            
            messagesOfUser.topAnchor.constraint(equalTo: commentsLabel.bottomAnchor,constant: 10),
            messagesOfUser.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressMessages.centerYAnchor.constraint(equalTo: messagesOfUser.centerYAnchor),
            progressMessages.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressMessages.widthAnchor.constraint(equalToConstant: 100),
            messageCount.trailingAnchor.constraint(equalTo: progressMessages.leadingAnchor,constant: -5),
            messageCount.centerYAnchor.constraint(equalTo: progressMessages.centerYAnchor),
            
            likedUserProfileLabel.topAnchor.constraint(equalTo: messagesOfUser.bottomAnchor,constant: 10),
            likedUserProfileLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressLikeYouUserAcc.centerYAnchor.constraint(equalTo: likedUserProfileLabel.centerYAnchor),
            progressLikeYouUserAcc.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressLikeYouUserAcc.widthAnchor.constraint(equalToConstant: 100),
            likeUserCount.trailingAnchor.constraint(equalTo: progressLikeYouUserAcc.leadingAnchor,constant: -5),
            likeUserCount.centerYAnchor.constraint(equalTo: progressLikeYouUserAcc.centerYAnchor),
            
            getCommentsLabel.topAnchor.constraint(equalTo: likedUserProfileLabel.bottomAnchor,constant: 10),
            getCommentsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressGetComments.centerYAnchor.constraint(equalTo: getCommentsLabel.centerYAnchor),
            progressGetComments.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressGetComments.widthAnchor.constraint(equalToConstant: 100),
            getCommentCount.trailingAnchor.constraint(equalTo: progressGetComments.leadingAnchor,constant: -5),
            getCommentCount.centerYAnchor.constraint(equalTo: progressGetComments.centerYAnchor),
            
            getMessagesLabel.topAnchor.constraint(equalTo: getCommentsLabel.bottomAnchor,constant: 10),
            getMessagesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressGetMessages.centerYAnchor.constraint(equalTo: getMessagesLabel.centerYAnchor),
            progressGetMessages.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressGetMessages.widthAnchor.constraint(equalToConstant: 100),
            getMessageCount.trailingAnchor.constraint(equalTo: progressGetMessages.leadingAnchor,constant: -5),
            getMessageCount.centerYAnchor.constraint(equalTo: progressGetMessages.centerYAnchor),
            
            likedYourUserLabel.topAnchor.constraint(equalTo: getMessagesLabel.bottomAnchor,constant: 10),
            likedYourUserLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressLikeYourAcc.centerYAnchor.constraint(equalTo: likedYourUserLabel.centerYAnchor),
            progressLikeYourAcc.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressLikeYourAcc.widthAnchor.constraint(equalToConstant: 100),
            getYourLikeeCount.trailingAnchor.constraint(equalTo: progressLikeYourAcc.leadingAnchor,constant: -5),
            getYourLikeeCount.centerYAnchor.constraint(equalTo: progressLikeYourAcc.centerYAnchor),
            
            followersLabel.topAnchor.constraint(equalTo: likedYourUserLabel.bottomAnchor,constant: 10),
            followersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressFollowers.centerYAnchor.constraint(equalTo: followersLabel.centerYAnchor),
            progressFollowers.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressFollowers.widthAnchor.constraint(equalToConstant: 100),
            followersCount.trailingAnchor.constraint(equalTo: progressFollowers.leadingAnchor,constant: -5),
            followersCount.centerYAnchor.constraint(equalTo: progressFollowers.centerYAnchor),
            
            postsLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor,constant: 10),
            postsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressPostsRating.centerYAnchor.constraint(equalTo: postsLabel.centerYAnchor),
            progressPostsRating.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressPostsRating.widthAnchor.constraint(equalToConstant: 100),
            postsCount.trailingAnchor.constraint(equalTo: progressPostsRating.leadingAnchor,constant: -5),
            postsCount.centerYAnchor.constraint(equalTo: progressPostsRating.centerYAnchor),
            
            playGameCountLabel.topAnchor.constraint(equalTo: postsLabel.bottomAnchor,constant: 10),
            playGameCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            progressPlayGameCount.centerYAnchor.constraint(equalTo: playGameCountLabel.centerYAnchor),
            progressPlayGameCount.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            progressPlayGameCount.widthAnchor.constraint(equalToConstant: 100),
            gameCount.trailingAnchor.constraint(equalTo: progressPlayGameCount.leadingAnchor,constant: -5),
            gameCount.centerYAnchor.constraint(equalTo: progressPlayGameCount.centerYAnchor),
        ])
    }
}
