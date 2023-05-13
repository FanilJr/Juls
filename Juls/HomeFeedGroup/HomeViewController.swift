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
    var user: User?
    var commentArray = [String]()
    var commentCount: Int?
    var likeCount: Int?
    var postIndexPath = 0
    
    var imageGif: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 100/2
        return image
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
        tableView.backgroundView = HomeEmptyStateView()
        tableView.register(BestRatingPeopleViewCell.self, forCellReuseIdentifier: "BestRatingPeopleViewCell")
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
        view.backgroundColor = .systemBackground
        layout()
        addInTable()
    }
    
    func addInTable() {
        let refreshControler = UIRefreshControl()
        refreshControler.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        refreshControler.attributedTitle = NSAttributedString(string: "Обновление")
        tableView.refreshControl = refreshControler
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alpha = 0.2
        fetchAllPosts()
    }
    
    private func setupWillAppear() {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func didTapRefresh() {
        let loadPostGif = UIImage.gifImageWithName("J2", speed: 4000)
        self.imageGif.image = loadPostGif
        UIView.animate(withDuration: 0.3) {
            self.tableView.alpha = 0.2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.fetchAllPosts()
        })
    }
    
    func fetchUserForImageBack() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: userId) { user in
            DispatchQueue.main.async {
                self.user = user
                self.imageBack.loadImage(urlString: user.picture)
            }
        }
    }
    
    fileprivate func fetchAllPosts() {
        fetchUserForImageBack()
        showEmptyStateViewIfNeeded()
        Database.database().fetchFeedPosts { posts in
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.backgroundView = nil
                self.tableView.refreshControl?.endRefreshing()
                self.imageGif.image = nil
                UIView.animate(withDuration: 0.3) {
                    self.tableView.alpha = 1
                }
                self.posts = posts
                self.tableView.reloadData()
            }
        }
    }

    func showEmptyStateViewIfNeeded() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        Database.database().numberOfItemsForUser(withUID: currentLoggedInUserId, category: "following") { (followingCount) in
            Database.database().numberOfItemsForUser(withUID: currentLoggedInUserId, category: "posts") { (postCount) in
                DispatchQueue.main.async {
                    if followingCount == 0 && postCount == 0 {
                        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                            self.tableView.backgroundView?.alpha = 1
                        }, completion: nil)
                        
                    } else {
                        self.tableView.backgroundView?.alpha = 0
                    }
                }
            }
        }
    }
    
    func layout() {
        let loadPostGif = UIImage.gifImageWithName("J2", speed: 4000)
        imageGif.image = loadPostGif
        [background,imageBack,blureForCell,tableView,imageGif].forEach { view.addSubview($0) }
        
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
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageGif.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageGif.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -50),
            imageGif.heightAnchor.constraint(equalToConstant: 100),
            imageGif.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return posts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BestRatingPeopleViewCell", for: indexPath) as! BestRatingPeopleViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.fetchUsers()
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
            cell.selectionStyle = .none
            if indexPath.row < posts.count {
                cell.configureHomeTable(post: posts[indexPath.row])
            }
            cell.delegate = self
            cell.backgroundColor = .clear
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print(indexPath)
        case 1:
            CommentViewController.showComment(self, post: posts[indexPath.row])
        default:
            tableView.cellForRow(at: indexPath)?.selectionStyle = .none
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return UITableView.automaticDimension
        default:
            return 200
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
        
        let post = self.posts[indexPath.row]
        
        guard let postId = post.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if post.hasLiked {
            Database.database().reference().child("likes").child(postId).child(uid).removeValue { (err, _) in
                DispatchQueue.main.async {
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
            }
        } else {
            let values = [uid: post.hasLiked == true ? 0 : 1]
            Database.database().reference().child("likes").child(postId).updateChildValues(values) { (err, _) in
                DispatchQueue.main.async {
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
}

extension HomeViewController: BestRatingPeopleProtocol {
    func getRating(user: User) {
        let ratingVC = RatingViewController()
        Database.database().fetchRaitingUser(withUID: user.uid) { rating in
            DispatchQueue.main.async {
                ratingVC.rating = rating
                if let sheet = ratingVC.sheetPresentationController {
                    sheet.detents = [.medium()]
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.preferredCornerRadius = 25
                    sheet.prefersGrabberVisible = true
                }
                self.present(ratingVC, animated: true)
            }
        }
    }
}
