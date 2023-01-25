//
//  PhotosTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit
import Firebase

protocol PhotosTableDelegate: AnyObject {
    func tuchUp()
}

class PhotosTableViewCell: UITableViewCell {
            
    weak var photosDelegate: PhotosTableDelegate?
    
    var user: User? {
        didSet {
            label.text = user?.name
        }
    }
    var post = [Post?]()
    
    var blureForCell: UIVisualEffectView = {
        let bluereEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blure = UIVisualEffectView()
        blure.effect = bluereEffect
        blure.translatesAutoresizingMaskIntoConstraints = false
        blure.clipsToBounds = true
        blure.layer.cornerRadius = 14
        return blure
    }()

    lazy var collectionViews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        return collectionView
    }()
        
    private let label: UILabel = {
        let label = UILabel()
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
            
        [blureForCell,collectionViews].forEach { contentView.addSubview($0) }
                            
        NSLayoutConstraint.activate([
            blureForCell.topAnchor.constraint(equalTo: contentView.topAnchor),
            blureForCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            blureForCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            blureForCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            
            collectionViews.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 12),
            collectionViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            collectionViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            collectionViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}

extension PhotosTableViewCell: UICollectionViewDelegate {

}

extension PhotosTableViewCell: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post.count
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.configurePhotos(post: post[indexPath.row])
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//
//        let recipe = galery[indexPath.row]
//
//        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
//            let share = UIAction(title: "Share", image: UIImage(systemName:"square.and.arrow.up.circle")) { _ in
//                print("Share")
//                let avc = UIActivityViewController(activityItems: [recipe], applicationActivities: nil)
//                print("В коллекции тап")
//            }
//            let menu = UIMenu(title: "", children: [share])
//            return menu
//        })
//        return configuration
//    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
        
    private var interSpace: CGFloat { return 10 }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let width = (collectionView.bounds.width - interSpace * 3) / 3
            
        return CGSize(width: width, height: width)
    }
}

extension PhotosTableViewCell {
    
    func configureFetchUser(user: User?) {
        self.user = user
        self.post.removeAll()
        self.configureFetchPostsUser(user: user)
    }
    
    func configureFetchPostsUser(user: User?) {
        guard let userData = user else { return }
        let ref = Database.database().reference().child("posts").child(userData.uid)
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            
            dictionaries.forEach { key, value in
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: userData, dictionary: dictionary)
                self.post.append(post)
            }
            self.post.sort { p1, p2 in
                return p1?.creationDate.compare(p2!.creationDate) == .orderedDescending
            }
            self.collectionViews.reloadData()
        }) { error in
            print("Failed to fetch posts:", error)
            return
        }
    }
}


