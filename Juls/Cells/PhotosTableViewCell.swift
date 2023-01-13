//
//  PhotosTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

protocol PhotosTableDelegate: AnyObject {
    func tuchUp()
}

class PhotosTableViewCell: UITableViewCell {
            
    weak var tuchNew: PhotosTableDelegate?

    private lazy var collectionViews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tuch() {
        print("tuch по кнопке из TableViewCell")
        tuchNew?.tuchUp()
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
            collectionViews.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

   

extension PhotosTableViewCell: UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
        return galery.count
            
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        cell.pullCell(photo: galery[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        let recipe = galery[indexPath.row]

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let share = UIAction(title: "Share", image: UIImage(systemName:"square.and.arrow.up.circle")) { _ in
                print("Share")
                let avc = UIActivityViewController(activityItems: [recipe], applicationActivities: nil)
                print("В коллекции тап")
            }
            let menu = UIMenu(title: "", children: [share])
            return menu
        })
        return configuration
    }
}

extension PhotosTableViewCell: UICollectionViewDelegateFlowLayout {
        
    private var interSpace: CGFloat { return 10 }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        let width = (collectionView.bounds.width - interSpace * 3) / 4
            
        return CGSize(width: width, height: width)
            
    }
}

