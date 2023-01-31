//
//  ProfileFriendsViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 06.01.2023.
//

import Foundation
import UIKit
import Firebase

class ProfileFriendsViewController: UIViewController {

    var user: User?
    var posts = [Post]()
    var post = [Post?]()
    var headerStretchy: StretchyCollectionFriendsHeaderView?
    private var refreshController = UIRefreshControl()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.clipsToBounds = true
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = CollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(StretchyCollectionFriendsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StretchyCollectionFriendsHeaderView")
        collectionView.register(MainFriendsCollectionViewCell.self, forCellWithReuseIdentifier: "MainFriendsCollectionViewCell")
        collectionView.register(PhotosFriendsCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosFriendsCollectionViewCell")
        collectionView.refreshControl = refreshController
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = user?.username
        layout()
        fetchUser()
        refreshController.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
//        self.posts.removeAll()
//        fetchUser()
        print("reload friendscontroller из-за этого вылетает когда посты не прогрузились")
    }
    
    @objc func didTapRefresh() {
        self.posts.removeAll()
        self.fetchUser()
        self.collectionView.reloadData()
        self.refreshController.endRefreshing()
    }
    
    static func show(_ viewController: UIViewController, user: User) {
        let ac = ProfileFriendsViewController()
        ac.user = user
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
    
    static func showUserAndPosts(_ viewController: UIViewController, user: User, post: [Post]) {
        let ac = ProfileFriendsViewController()
        ac.user = user
        ac.post = post
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
    
    func layout() {
        [background, collectionView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: background.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: background.bottomAnchor)
        ])
    }
}

extension ProfileFriendsViewController {
    
    func fetchUser() {
        guard let uid = user?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.fetchPostsWithUser(user: user)
            print("Перезагрузка в ProfileFriendsViewController fetchUser")
        }
    }
    func fetchPostsWithUser(user: User) {
        
    let ref = Database.database().reference().child("posts").child(user.uid)

        ref.observeSingleEvent(of: .value, with: { snapshot in
        guard let dictionaries = snapshot.value as? [String: Any] else { return }
        
        dictionaries.forEach { key, value in
            guard let dictionary = value as? [String: Any] else { return }
            let post = Post(user: user, dictionary: dictionary)
            self.posts.append(post)
        }
            self.posts.sort { p1, p2 in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            }
        self.collectionView.reloadData()
            print("Перезагрузка в ProfileFriendsViewController fetchPostWithUser")
        }) { error in
            print("Failed to fetch posts:", error)
            return
        }
    }
}

extension ProfileFriendsViewController: UICollectionViewDelegate {
    
}

extension ProfileFriendsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return posts.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainFriendsCollectionViewCell", for: indexPath) as! MainFriendsCollectionViewCell
            cell.configureMain(user: self.user)
            cell.checkIFollowing(user: self.user)
            cell.checkFollowMe(user: self.user)
            cell.loadFollowUsers(user: self.user)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosFriendsCollectionViewCell", for: indexPath) as! PhotosFriendsCollectionViewCell
//            cell.post = posts[indexPath.item]
            cell.post = posts[indexPath.item]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            headerStretchy = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StretchyCollectionFriendsHeaderView", for: indexPath) as? StretchyCollectionFriendsHeaderView
            headerStretchy?.delegate = self
            headerStretchy?.user = self.user
            return headerStretchy!
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            PostTableViewController.showPostTableViewController(self, post: self.posts[indexPath.item])
        default:
            print("")
        }
    }
}

extension ProfileFriendsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: self.collectionView.frame.size.width, height: 570)
        case 1:
            return CGSize()
        default:
            return CGSize()
        }
    }
    
    private var interSpace: CGFloat { return 8 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            let width = collectionView.bounds.width
            let height = CGFloat(220.0)
            return CGSize(width: width, height: height)
            
        case 1:
            let width = (collectionView.bounds.width - interSpace * 4) / 3
            return CGSize(width: width, height: width)
            
        default:
            return CGSize()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return CGFloat()
        case 1:
            return interSpace
        default:
            return CGFloat()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 0:
            return UIEdgeInsets()
        case 1:
            return UIEdgeInsets(top: interSpace, left: interSpace, bottom: interSpace, right: interSpace)
        default:
            return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return CGFloat()
        case 1:
            return interSpace
        default:
            return CGFloat()
        }
    }
}

extension ProfileFriendsViewController: StretchyFriendsDelegate {
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
