//
//  CommentsSheetViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 16.03.2023.
//

import Foundation
import UIKit
import Firebase

class CommentsSheetViewController: UIViewController {
    
    var myUserComment: User?
    var comments = [Comment]()
    var post: Post?
    
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
    
    private lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
//        textfield.placeholder = "Напишите комментарий"
        textfield.layer.cornerRadius = 10
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
    
    lazy var sendCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.1758851111, green: 0.5897727013, blue: 0.9195605516, alpha: 1)
        button.setTitleColor(.createColor(light: .black, dark: .white), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pushMessage), for: .touchUpInside)
        return button
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
        view.backgroundColor = .systemBackground
        layout()
        fetchCommentsPost()
    }
    
    func waitingSpinnerForTableEnable(_ active: Bool) {
        if active {
            spinnerViewForTable.startAnimating()
        } else {
            spinnerViewForTable.stopAnimating()
        }
    }
    
    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
    
    @objc func pushMessage() {
        self.sendCommentButton.isEnabled = false
        self.sendCommentButton.alpha = 0
        self.waitingSpinnerEnable(true)
        guard let postId = post?.id else { return }
        guard let textComment = textfield.text else { return }
        
        Database.database().addCommentToPost(withId: postId, text: textComment) { error in
            if let error {
                print(error)
            }
            print("success insert comment:", textComment)
            self.fetchCommentsPost()
            self.sendCommentButton.isEnabled = true
            self.sendCommentButton.alpha = 1
            self.waitingSpinnerEnable(false)
        }
        textfield.text = ""
    }
    
    func layout() {
        
        [textfield,tableView,sendCommentButton,spinnerViewForTable,spinnerView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            textfield.topAnchor.constraint(equalTo: view.topAnchor,constant: 20),
            textfield.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 10),
            textfield.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            textfield.heightAnchor.constraint(equalToConstant: 35),
            
            sendCommentButton.centerYAnchor.constraint(equalTo: textfield.centerYAnchor),
            sendCommentButton.trailingAnchor.constraint(equalTo: textfield.trailingAnchor,constant: -10),
            
            spinnerView.centerYAnchor.constraint(equalTo: sendCommentButton.centerYAnchor),
            spinnerView.centerXAnchor.constraint(equalTo: sendCommentButton.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: textfield.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinnerViewForTable.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinnerViewForTable.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    func fetchCommentsPost() {
        waitingSpinnerForTableEnable(true)
        guard let postId = self.post?.id else { return }
        Database.database().fetchCommentsForPost(withId: postId) { comments in
            DispatchQueue.main.async {
                self.comments.removeAll()
                self.comments = comments
                if comments.isEmpty {
                    self.textfield.placeholder = "Напишите первый комментарий"
                } else {
                    self.textfield.placeholder = "Напишите комментарий"
                }
                self.waitingSpinnerForTableEnable(false)
                self.tableView.reloadData()
            }
        }
    }
}

extension CommentsSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as! CommentsTableViewCell
        cell.comments = comments[indexPath.row]
        return cell
    }
}

extension CommentsSheetViewController: UITableViewDelegate {
    
}

extension CommentsSheetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
