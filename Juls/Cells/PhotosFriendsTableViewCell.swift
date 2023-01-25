//
//  PhotosFriendsTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 23.01.2023.
//

import Foundation
import UIKit
import Firebase

class PhotosFriendsTableViewCell: UITableViewCell {
            
    weak var photosDelegate: PhotosTableDelegate?
    var user: User?
    var posts = [Post]()

    lazy var collectionViews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomFriendsCollectionViewCell.self, forCellWithReuseIdentifier: "CustomFriendsCollectionViewCell")
        return collectionView
    }()
        
    private let label: UILabel = {
        let label = UILabel()
        label.text = "profile.photos".localized
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private let button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "rectangle.grid.3x2"), for: .normal)
        button.tintColor = .createColor(light: .black, dark: .white)
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(tuch), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        fetchUser()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tuch() {
        print("tuch по кнопке из TableViewCell")
        photosDelegate?.tuchUp()
    }
    
    @objc private func tuchShare() {
        
    }
    
    private func layout() {
            
        [collectionViews].forEach { contentView.addSubview($0) }
                            
        NSLayoutConstraint.activate([
            collectionViews.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            collectionViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            collectionViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            collectionViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            collectionViews.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
}

   

extension PhotosFriendsTableViewCell: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
        return posts.count
            
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomFriendsCollectionViewCell", for: indexPath) as! CustomFriendsCollectionViewCell
        cell.post = posts[indexPath.row]
        return cell
    }
}

extension PhotosFriendsTableViewCell: UICollectionViewDelegateFlowLayout {
        
    private var interSpace: CGFloat { return 10 }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let width = (collectionView.bounds.width - interSpace * 3) / 3
            
        return CGSize(width: width, height: width)
            
    }
}

extension PhotosFriendsTableViewCell {
    
    func fetchUser() {
        guard let uid = user?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.collectionViews.reloadData()
            self.fetchPostsWithUser(user: user)
            print("Перезагрузка в ProfileViewController fetchUser")
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
        self.collectionViews.reloadData()
        }) { error in
            print("Failed to fetch posts:", error)
            return
        }
    }
}
