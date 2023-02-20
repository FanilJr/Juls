//
//  PostViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 26.01.2023.
//

import Foundation
import UIKit
import Firebase

class PostTableViewController: UIViewController {
    
    var post: Post?
    var juls = JulsView()
    var commentArray = [String]()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.clipsToBounds = true
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupDidDisappear()
    }
    
    private func setupDidLoad() {
        navigationItem.titleView = juls
        layout()
        countComment(post: post)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupWillAppear() {
        navigationController?.hidesBarsOnSwipe = true
        let height = tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y += height!
        }
    }
    
    private func setupDidDisappear() {
        let height = tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y -= height!
        }
    }

    func layout() {
        [background,tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PostTableViewController: UITableViewDelegate {
    
}

extension PostTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = .clear
        cell.delegate = self
        cell.commentCountLabel.text = "Комментарии (\(commentArray.count))"
        cell.configureTable(post: self.post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PostTableViewController: CommentDelegate {
    
    func didTapLike(for cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        guard let postId = post?.id else { return }
        if var post = post {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = [uid: post.hasLiked == true ? 0 : 1]
            DispatchQueue.main.async {
                Database.database().reference().child("likes").child(postId).updateChildValues(values) { [self] error, _ in
                    if let error {
                        print(error)
                        return
                    }
                    print("successfully liked post")
                    post.hasLiked = !post.hasLiked
                    self.post = post
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func didTapComment() {
        CommentViewController.showComment(self, post: post)
    }
    
    func countComment(post: Post?) {
        guard let uid = post?.id else { return }
        DispatchQueue.main.async {
            Database.database().reference().child("comments").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! Firebase.DataSnapshot
                    let key = snap.key
                    self.commentArray.append(key)
                }
                self.tableView.reloadData()
            })
        }
    }
}
