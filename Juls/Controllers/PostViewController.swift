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
    
    var post: Post? {
        didSet {
            fetchPost()
        }
    }
    var juls = JulsView()
    var commentArray = [String]()
    var commentCount: Int?
    
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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupWillAppear() {
        self.navigationController?.hidesBarsOnSwipe = true
        let height = self.tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y += height!
        }
    }
    
    private func setupDidDisappear() {
        let height = self.tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y -= height!
        }
    }
    
    func fetchPost() {
        guard let imageUrl = self.post?.imageUrl else { return }
        DispatchQueue.main.async {
            self.imageBack.loadImage(urlString: imageUrl)
            Database.database().fetchCommetsCount(withPostId: self.post?.id ?? "") { count in
                DispatchQueue.main.async {
                    self.commentCount = count
                    self.tableView.reloadData()
                }
            }
        }
    }

    func layout() {
        [background,imageBack,blureForCell,tableView].forEach { view.addSubview($0) }
        
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
        cell.commentCountLabel.text = "Комментарии (\(commentCount ?? 0))"
        cell.configureTable(post: self.post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PostTableViewController: CommentDelegate {
    
    func didTapLike(for cell: PostTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        guard let postId = self.post?.id else { return }
        if var post = self.post {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let values = [uid: post.hasLiked == true ? 0 : 1]
            Database.database().reference().child("likes").child(postId).updateChildValues(values) { [self] error, _ in
                if let error {
                    print(error)
                    return
                }
                print("successfully liked post:", post.message)
                post.hasLiked = !post.hasLiked
                self.post = post
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func didTapComment() {
        CommentViewController.showComment(self, post: post)
    }
}
