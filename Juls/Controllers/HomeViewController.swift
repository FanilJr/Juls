//
//  PostViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 07.01.2023.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {

    
    var posts = [Post]()
    var juls = JulsView()
    var user: User?
    var commentArray = [String]()
    var commentCount: Int?
    var likeCount: Int?
    var postIndexPath = 0
    var refreshControler = UIRefreshControl()
    
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
        tableView.backgroundView = HomeEmptyStateView()
        tableView.refreshControl = refreshControler
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "HomeTableViewCell")
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
        title = "Лента"
        fetchUserForImageBack()
        tableView.delegate = self
        tableView.dataSource = self
        layout()
        fetchAllPosts()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
    }
    
    private func setupWillAppear() {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func didTapRefresh() {
        self.fetchAllPosts()
    }
    
    func fetchUserForImageBack() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: userId) { user in
            self.user = user
            self.imageBack.loadImage(urlString: user.picture)
        }
    }
    
    fileprivate func fetchAllPosts() {
        self.posts.removeAll()
        showEmptyStateViewIfNeeded()
        fetchPostsForCurrentUser()
        fetchFollowingUserPosts()
    }
    
    private func fetchPostsForCurrentUser() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }

        tableView.refreshControl?.beginRefreshing()

        Database.database().fetchAllPosts(withUID: currentLoggedInUserId, completion: { (posts) in
            self.posts.append(contentsOf: posts)
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })

            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }) { (err) in
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    private func fetchFollowingUserPosts() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        tableView.refreshControl?.beginRefreshing()

        Database.database().reference().child("following").child(currentLoggedInUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }

            userIdsDictionary.forEach({ (uid, value) in
                Database.database().fetchAllPosts(withUID: uid, completion: { (posts) in
                    self.posts.append(contentsOf: posts)
                    self.posts.sort(by: { (p1, p2) -> Bool in
                        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                    })
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()

                }, withCancel: { (err) in
                    self.tableView.refreshControl?.endRefreshing()
                })
            })
        }) { (err) in
            self.tableView.refreshControl?.endRefreshing()
        }
    }

    func showEmptyStateViewIfNeeded() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        Database.database().numberOfFollowingForUser(withUID: currentLoggedInUserId) { (followingCount) in
            Database.database().numberOfPostsForUser(withUID: currentLoggedInUserId, completion: { (postCount) in

                if followingCount == 0 && postCount == 0 {
                    UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                        self.tableView.backgroundView?.alpha = 1
                    }, completion: nil)

                } else {
                    self.tableView.backgroundView?.alpha = 0
                }
            })
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

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if indexPath.row < posts.count {
            cell.configureHomeTable(post: posts[indexPath.row])
        }
        cell.delegate = self
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommentViewController.showComment(self, post: posts[indexPath.row])
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension HomeViewController: HomeTableDelegate {
    
    
    func tapComment(for cell: HomeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        CommentViewController.showComment(self, post: posts[indexPath.row])
    }
    
    func didLike(for cell: HomeTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        var post = self.posts[indexPath.row]
        
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if post.hasLiked {
            Database.database().reference().child("likes").child(postId).child(uid).removeValue { (err, _) in
                if let err = err {
                    print("Failed to unlike post:", err)
                    return
                }
                post.hasLiked = false
                post.likes = post.likes - 1
                self.posts[indexPath.item] = post
                print(post.likes)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else {
            let values = [uid: post.hasLiked == true ? 0 : 1]
            Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
                if let err = err {
                    print("Failed to like post:", err)
                    return
                }
                post.hasLiked = true
                post.likes = post.likes + 1
                self.posts[indexPath.item] = post
                print(post.likes)
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}
