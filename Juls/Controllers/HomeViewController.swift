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
    var commentArray = [String]()
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
        navigationItem.titleView = juls

        tableView.delegate = self
        tableView.dataSource = self
        layout()
        fetchAllPosts()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
    }
    
    private func setupWillAppear() {
        tabBarController?.tabBar.isHidden = false
        navigationController?.hidesBarsOnSwipe = true
    }
    
    @objc func didTapRefresh() {
        posts.removeAll()
        self.fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserUids()
        self.tableView.reloadData()
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
        cell.configureHomeTable(post: posts[indexPath.row])
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

extension HomeViewController {
    
    func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: uid) { user in
            DispatchQueue.main.async {
                self.imageBack.loadImage(urlString: user.picture)
                self.fetchPostsWithUser(user: user)
            }
        }
    }
    
    func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                self.tableView.refreshControl?.endRefreshing()
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
        
                dictionaries.forEach ({ (key, value) in
                    guard let dictionary = value as? [String: Any] else { return }
                    var post = Post(user: user, dictionary: dictionary)
                    post.id = key
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let value = snapshot.value as? Int, value == 1 {
                            post.hasLiked = true
                        } else {
                            post.hasLiked = false
                        }
                        self.posts.append(post)
                        self.posts.sort { p1, p2 in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }, withCancel: { (error) in
                        print(error)
                    })
                })
            }) { error in
                print("Failed to fetch posts:", error)
            }
        }
    }
    
    func fetchFollowingUserUids() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        DispatchQueue.main.async {
            Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
                userIdsDictionary.forEach ({ (key, value) in
                    Database.database().fetchUser(withUID: key) { user in
                        self.fetchPostsWithUser(user: user)
                    }
                })
            }) { (error) in
                print("error")
            }
        }
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
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { error, ref in
            if let error {
                print(error)
                return
            }
            print("successfully liked post")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.row] = post
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}
