//
//  CommentViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 11.02.2023.
//

import Foundation
import UIKit
import Firebase

class CommentViewController: UIViewController {
    
    var myUserComment: User?
    var post: Post?
    var rating: Raiting?
    var myRating: Raiting?
    var comments = [Comment]()
    var headerComment = HeaderCommment()
    var commentKeyArray = [String]()
    var currentIndex = 0
    var ratingView = RatingView()
    private let nc = NotificationCenter.default
    
    var fetchCommentsForRaitin: Bool = false

    lazy var containerView: UIView = {
        let containterView = UIView()
        containterView.backgroundColor = .systemGray6
        containterView.translatesAutoresizingMaskIntoConstraints = false
        return containterView
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = UIColor.createColor(light: .black, dark: .white)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private let spinnerViewForTable: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = UIColor.createColor(light: .black, dark: .white)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    lazy var blureForCell: UIVisualEffectView = {
        let bluereEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blure = UIVisualEffectView()
        blure.effect = bluereEffect
        blure.translatesAutoresizingMaskIntoConstraints = false
        blure.clipsToBounds = true
        return blure
    }()
    
    lazy var imageBack: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 50/2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
            
    lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "Enter comment"
        textfield.layer.cornerRadius = 16
        textfield.clipsToBounds = true
        textfield.backgroundColor = .systemBackground
        textfield.textColor = UIColor.createColor(light: .black, dark: .white)
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 0.5
        textfield.setLeftPaddingPoints(12)
        textfield.setRightPaddingPoints(40)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var authorComment: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "Grey_full")
        image.layer.cornerRadius = 30/2
        image.clipsToBounds = true
        return image
    }()
    
    lazy var sendCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushComment), for: .touchUpInside)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.1758851111, green: 0.5897727013, blue: 0.9195605516, alpha: 1)
        button.setTitleColor(.createColor(light: .black, dark: .white), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(recognizer)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWillAppear()
    }
    
    private func setupDidLoad() {
        headerComment.post = post
        guard let imageUrl = post?.imageUrl else { return }
        imageBack.loadImage(urlString: imageUrl)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: uid) { user in
            self.myUserComment = user
            self.authorComment.loadImage(urlString: user.picture)
        }
        title = "Комментарии"
        setupLayout()
        fetchCommentsPost()
        waitingSpinnerEnable(activity: self.spinnerViewForTable, active: true)
    }
    
    private func setupWillAppear() {
        addObserver()
        tabBarController?.tabBar.isHidden = true
    }
    
    func fetchCommentsPost() {
        guard let uid = post?.user.uid else { return }
        guard let myUID = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchCommentsForRaiting(withUID: uid) { value in
            self.fetchCommentsForRaitin = value
            print(value)
        }
        Database.database().fetchRaitingUser(withUID: uid) { raiting in
            self.rating = raiting
        }
        Database.database().fetchRaitingUser(withUID: myUID) { raiting in
            self.myRating = raiting
        }
        
        guard let postId = self.post?.id else { return }
        Database.database().fetchCommentsForPost(withId: postId) { comments in
            DispatchQueue.main.async {
                self.comments.removeAll()
                self.comments = comments
                self.tableView.setContentOffset(CGPointMake(0, self.containerView.center.y-60), animated: true)
                waitingSpinnerEnable(activity: self.spinnerViewForTable, active: false)
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func pushComment() {
        self.sendCommentButton.isEnabled = false
        self.sendCommentButton.alpha = 0
        waitingSpinnerEnable(activity: self.spinnerView, active: true)
        guard let postId = post?.id else { return }
        guard let textComment = textfield.text else { return }
        guard let userId = self.post?.user.uid else { return }
        
        Database.database().addCommentToPost(withId: postId, text: textComment) { error in
            if let error {
                print(error)
                return
            }
            guard let uid = self.myUserComment?.uid else { return }
            guard let activity = self.myRating?.commentsRating else { return }
            guard let getActivity = self.rating?.getCommentsRating else { return }
            
            print(activity)
            
            if activity == 1.0 {
                print("success insert comment:", textComment)
                self.textfield.text = ""
                self.sendCommentButton.isEnabled = true
                self.sendCommentButton.alpha = 1
                waitingSpinnerEnable(activity: self.spinnerView, active: false)
                self.fetchCommentsPost()
                return
            } else {
                var addActivity = 0.01
                var addgetActivity = 0.01
                addgetActivity += getActivity
                addActivity += activity
                let getResult = addgetActivity
                let result = addActivity
                Database.database().addCommentForUserRaiting(withUID: userId) { error in
                    if let error {
                        print(error)
                        return
                    }
                }
                
                if self.fetchCommentsForRaitin == false {
                    Database.database().reference().child("rating").child(uid).updateChildValues(["commentsRating" : result]) { error, _ in
                        if let error {
                            print(error)
                            return
                        }
                        self.animateRating()
                        print("succes update commentsRaiting in Firebase Library + 0.01")
                        Database.database().reference().child("rating").child(userId).updateChildValues(["getComments" : getResult]) { error, _ in
                            if let error {
                                print(error)
                                return
                            }
                            print("succes update getComments for", userId, "+ 0.01")
                        }
                    }
                }

                print("success insert comment:", textComment)
                self.textfield.text = ""
                self.sendCommentButton.isEnabled = true
                self.sendCommentButton.alpha = 1
                waitingSpinnerEnable(activity: self.spinnerView, active: false)
                self.fetchCommentsPost()
            }
        }
    }
    
    func addObserver() {
        nc.addObserver(self, selector: #selector(kdbShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kdbHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeObserver() {
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func kdbShow(notification: NSNotification) {
        
        if let kdbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom = kdbSize.height
            tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kdbSize.height, right: 0)
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -kdbSize.height)
            tableView.setContentOffset(CGPointMake(0, containerView.center.y-60), animated: true)
        }
    }

    @objc func kdbHide() {
        tableView.contentInset.bottom = .zero
        tableView.verticalScrollIndicatorInsets = .zero
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func animateRating() {
        print("ANIMATE")
        view.addSubview(ratingView)
        ratingView.rating.text = "+ 0.01"
        
        NSLayoutConstraint.activate([
            ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ratingView.heightAnchor.constraint(equalTo: view.widthAnchor),
            ratingView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        animateElementRating(object: ratingView, animate: true, duration: 0.8, delay: 0, yTransform: -200, xTransform: 0)
        animateElementRating(object: ratingView, animate: false, duration: 0.5, delay: 1, yTransform: 0, xTransform: 0)
    }
    
    func setupLayout() {
        [background,imageBack,blureForCell,tableView,spinnerViewForTable,containerView].forEach { view.addSubview($0) }
        [authorComment, textfield, sendCommentButton,spinnerView].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageBack.topAnchor.constraint(equalTo: view.topAnchor),
            imageBack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blureForCell.topAnchor.constraint(equalTo: imageBack.topAnchor),
            blureForCell.leadingAnchor.constraint(equalTo: imageBack.leadingAnchor),
            blureForCell.trailingAnchor.constraint(equalTo: imageBack.trailingAnchor),
            blureForCell.bottomAnchor.constraint(equalTo: imageBack.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: background.topAnchor),
            tableView.leftAnchor.constraint(equalTo: background.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: background.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            
            spinnerViewForTable.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinnerViewForTable.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 70),
            
            authorComment.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 12),
            authorComment.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10),
            authorComment.widthAnchor.constraint(equalToConstant: 30),
            authorComment.heightAnchor.constraint(equalToConstant: 30),
            
            textfield.centerYAnchor.constraint(equalTo: authorComment.centerYAnchor),
            textfield.leadingAnchor.constraint(equalTo: authorComment.trailingAnchor,constant: 10),
            textfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -5),
            textfield.heightAnchor.constraint(equalToConstant: 35),
            
            sendCommentButton.centerYAnchor.constraint(equalTo: authorComment.centerYAnchor),
            sendCommentButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20),
            sendCommentButton.heightAnchor.constraint(equalToConstant: 50),
            
            spinnerView.centerYAnchor.constraint(equalTo: sendCommentButton.centerYAnchor),
            spinnerView.centerXAnchor.constraint(equalTo: sendCommentButton.centerXAnchor)
        ])
    }
    
    func getAllKeys() {
        guard let uid = post?.id else { return }
        Database.database().reference().child("comments").child(uid).observeSingleEvent(of: .value) { snapshot in
            snapshot.children.forEach { child in
                let snap = child as! DataSnapshot
                let key = snap.key
                self.commentKeyArray.append(key)
            }
        }
    }
    
    static func showComment(_ viewController: UIViewController, post: Post?) {
        let ac = CommentViewController()
        ac.post = post
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        cell.comments = comments[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        getAllKeys()
        if Auth.auth().currentUser?.uid == comments[indexPath.row].uid {
            guard let uid = post?.id else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                Database.database().reference().child("comments").child(uid).child(self.commentKeyArray[indexPath.item]).removeValue()
                self.commentKeyArray.remove(at: indexPath.row)
                print("remove",self.comments[indexPath.item].text)
                self.comments.remove(at: indexPath.item)
                self.tableView.deleteRows(at: [indexPath], with: .right)
                guard let uid = Auth.auth().currentUser?.uid else { return }
                Database.database().fetchRaitingUser(withUID: uid) { raiting in
                    let activity = raiting.commentsRating
                    let deleteActivity = 0.05
                    var activityDouble = activity
                    activityDouble -= deleteActivity
                    Database.database().reference().child("rating").child(uid).updateChildValues(["commentsRating" : activityDouble]) { error, _ in
                        if let error {
                            print(error)
                            return
                        }
                        print("succes delete rating - 0.01")
                    }
                }
            })
            tableView.endUpdates()
        } else {
            let alertController = UIAlertController(title: "Нельзя удалить чужой комментарий", message: "Sorry", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "ок", style: .cancel)
            alertController.addAction(actionCancel)
            present(alertController, animated: true)
            tableView.endUpdates()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerComment
    }
}

extension CommentViewController: UITableViewDelegate {
    
}

extension UITextField {
    func setupLeftView() {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: "ellipsis.message.fill")
        imageView.tintColor = .black
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        let imageViewContrainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageViewContrainerView.addSubview(imageView)
        leftView = imageViewContrainerView
        leftViewMode = .always
    }
}

extension CommentViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
        return true
    }
}

extension CommentViewController {
    func tapScreen() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
}
