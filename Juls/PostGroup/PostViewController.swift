//
//  PostViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 26.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol PostViewControllerDelegate: AnyObject {
    func reloadTable()
}

class PostTableViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    var cgfloatTabBar: CGFloat?
    var post: Post? {
        didSet {
            if post?.user.uid == Auth.auth().currentUser?.uid {
                let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAction))
                deleteButton.tintColor = UIColor.createColor(light: .red, dark: .red)
                navigationItem.rightBarButtonItem = deleteButton
            }
            guard let stringTile = self.post?.message else { return }
            title = stringTile
            guard let imageUrl = self.post?.imageUrl else { return }
            imageBack.loadImage(urlString: imageUrl)
        }
    }
    var raiting: Raiting?
    var commentArray = [String]()
    var rating: Raiting?
    var fetchLike: Bool = false
    
    lazy var imageBack: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.alpha = 0.1
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWillAppear()
    }
    
    private func setupDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        let height = self.tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y += height!
            self.cgfloatTabBar = self.tabBarController?.tabBar.frame.origin.y
        }
        layout()
    }
    
    private func setupWillAppear() {
        let height = self.tabBarController?.tabBar.frame.height
        if tabBarController?.tabBar.frame.origin.y != self.cgfloatTabBar {
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.frame.origin.y += height!
            }
        }
    }
    
    @objc func deleteAction() {
        let alertController = UIAlertController(title: "Удалить пост", message: "Вы действительно хотите удалить пост?", preferredStyle: .alert)
        let alertDelete = UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            Database.database().deletePost(withUID: self.post?.user.uid ?? "", postId: self.post?.id ?? "")
            self.navigationController?.popViewController(animated: true)
            self.delegate?.reloadTable()
        })
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel)
        [alertCancel,alertDelete].forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
    func fetchLikes() {
        guard let uid = post?.user.uid else { return }
        Database.database().fetchLikeForRaiting(withUID: uid) { value in
            DispatchQueue.main.async {
                self.fetchLike = value
            }
        }
    }
    
    static func showPost(_ viewController: UIViewController, post: Post) {
        let ac = PostTableViewController()
        ac.post = post
        viewController.navigationController?.pushViewController(ac, animated: true)
    }

    func layout() {
        [imageBack,tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageBack.topAnchor.constraint(equalTo: view.topAnchor),
            imageBack.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageBack.rightAnchor.constraint(equalTo: view.rightAnchor),
            imageBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        fetchLikes()
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
        cell.post = self.post
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PostTableViewController: CommentDelegate {
    
    func didTapLike(for cell: PostTableViewCell) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        guard let postId = self.post?.id else { return }

        if var post = self.post {
            if post.hasLiked == false {
            
                let values = [uid : 1]
                Database.database().reference().child("likes").child(postId).updateChildValues(values) { [self] error, _ in
                    if let error {
                        print(error)
                        return
                    }
                    
                    print("successfully liked post:", post.message)
                    post.hasLiked = !post.hasLiked
                    post.likes = post.likes + 1
                    self.post = post
                    print(post.likes)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.fetchLikes()
                }
            } else {
                Database.database().reference().child("likes").child(postId).child(uid).removeValue { (err, _) in
                    if let err = err {
                        print("Failed to unlike post:", err)
                        return
                    }
                    post.hasLiked = !post.hasLiked
                    post.likes = post.likes - 1
                    self.post = post
                    print(post.likes)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.fetchLikes()
                }
            }
        }
    }
    
    func didtapImageComment() {
        let commentVC = CommentViewController()
        commentVC.post = post
        navigationController?.pushViewController(commentVC, animated: true)
    }
}
