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
    var comments = [Comment]()
    var headerComment = HeaderCommment()
    var commentKeyArray = [String]()
    private let nc = NotificationCenter.default

    lazy var containerView: UIView = {
        let containterView = UIView()
        containterView.backgroundColor = .white
        containterView.translatesAutoresizingMaskIntoConstraints = false
        return containterView
    }()
            
    lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "Enter comment"
        textfield.layer.cornerRadius = 16
        textfield.clipsToBounds = true
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 0.5
        textfield.setLeftPaddingPoints(12)
        textfield.setRightPaddingPoints(36)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var authorComment: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30/2
        image.clipsToBounds = true
        return image
    }()
    
    lazy var sendCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pushComment), for: .touchUpInside)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .systemBlue
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
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentsTableViewCell.self, forCellReuseIdentifier: "CommentsTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerComment.post = post
        title = "Комментарии"
        setupLayout()
        tapScreen()
        fetchComments()
        loadImageCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func loadImageCurrentUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.myUserComment = user
            self.authorComment.loadImage(urlString: user.picture)
        }
    }
    
    func fetchComments() {
        guard let postId = self.post?.id else { return }
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid) { user in
                let comment = Comment(user: user, dictionary: dictionary)
                self.comments.append(comment)
                self.tableView.reloadData()
            }
        })
    }
    
    @objc func pushComment() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        print("post Id", self.post?.id ?? "")
        print("push comment", textfield.text ?? "")
        let postId = self.post?.id ?? ""
        let values = ["text" : textfield.text ?? "", "creationDate" : Date().timeIntervalSince1970, "uid" : uid] as [String:Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { error, ref in
            if let error {
                print(error)
                return
            }
            print("success insert comment")
        }
        textfield.text = ""
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
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -330)
        }
    }

    @objc func kdbHide() {
        tableView.contentInset.bottom = .zero
        tableView.verticalScrollIndicatorInsets = .zero
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func setupLayout() {
        [background,tableView,containerView].forEach { view.addSubview($0) }
        [authorComment, textfield, sendCommentButton].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: background.topAnchor),
            tableView.leftAnchor.constraint(equalTo: background.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: background.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            
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
            sendCommentButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -15),
            sendCommentButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
        cell.configureComments(comment: comments[indexPath.row])
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        getAllKaysPost()
        if Auth.auth().currentUser?.uid == comments[indexPath.row].uid {
            comments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            guard let uid = post?.id else { return }
            print(post?.id as Any)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                Database.database().reference().child("comments").child(uid).child(self.commentKeyArray[indexPath.item]).removeValue()
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
    
    func getAllKaysPost() {
        guard let uid = post?.id else { return }
        Database.database().reference().child("comments").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! Firebase.DataSnapshot
                let key = snap.key
                self.commentKeyArray.insert(key, at: 0)
            }
        })
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
    
    func paddingUp() {
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
