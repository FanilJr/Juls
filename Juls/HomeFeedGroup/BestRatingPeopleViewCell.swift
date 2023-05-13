//
//  StorysTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 11.03.2023.
//

import Foundation
import UIKit
import Firebase

protocol BestRatingPeopleProtocol: AnyObject {
    func getRating(user: User)
}

class BestRatingPeopleViewCell: UITableViewCell {
    
    var peoples = [User]()
    weak var delegate: BestRatingPeopleProtocol?
    
    var bestRatingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Лучшие в Juls"
        label.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        label.font = UIFont(name: "Futura-Bold", size: 25)
        label.shadowOffset = CGSize(width: 1, height: 1)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .systemGray6
        collection.clipsToBounds = true
        collection.layer.cornerRadius = 20
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchUsers() {
        Database.database().fetchTopTenUsersRating { users in
            DispatchQueue.main.async {
                self.peoples = users
                self.collectionView.reloadData()
            }
        }
    }
    
    func layout() {
        [bestRatingLabel,collectionView].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            bestRatingLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            bestRatingLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: bestRatingLabel.bottomAnchor,constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 92)
        ])
    }
}

extension BestRatingPeopleViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return peoples.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.setupPeople(user: peoples[indexPath.row])
        cell.backgroundColor = .clear
        
        if indexPath.row == 0 {
            cell.kingImage.alpha = 1.0
        } else {
            cell.kingImage.alpha = 0.0
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = peoples[indexPath.row]
        delegate?.getRating(user: user)
    }
}

extension BestRatingPeopleViewCell: UICollectionViewDelegateFlowLayout {

    private var spacing: CGFloat { return 5 }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - spacing * 15) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}
