//
//  MainTableViewCell.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit
import Firebase
import FirebaseDatabase

protocol MainEditDelegate: AnyObject {
    func tapOpenEditInfo()
    func tapEditingStatusLife()
    func tapEditInfo()
}
class MainTableViewCell: UITableViewCell {
    
    weak var delegate: MainEditDelegate?
    
    private lazy var lineUp: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor.createColor(light: .black, dark: .white)
        line.contentMode = .scaleAspectFill
        line.layer.cornerRadius = 3
        line.clipsToBounds = true
        return line
    }()
    
    private lazy var info: UILabel = {
        let name = UILabel()
        name.text = "О себе:"
        name.font = UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var first: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Имя:"
        return nothing
    }()
    
    lazy var two: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Возраст:"
        return nothing
    }()
    
    lazy var three: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Семейное положение:"
        return nothing
    }()
    
    lazy var four: UILabel = {
        let nothing = UILabel()
        nothing.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        nothing.translatesAutoresizingMaskIntoConstraints = false
        nothing.text = "Рост:"
        return nothing
    }()
    
    lazy var name: UILabel = {
        let name = UILabel()
        name.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        name.translatesAutoresizingMaskIntoConstraints = false
        return name
    }()
    
    lazy var friends: UILabel = {
        let status = UILabel()
        status.font = UIFont.systemFont(ofSize: 12.0, weight: .light)
        status.translatesAutoresizingMaskIntoConstraints = false
        return status
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var statusLife: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heightUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ageUser: UILabel = {
        let label = UILabel()
        label.textColor = .createColor(light: .black, dark: .white)
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "pencil.circle"), for: .normal)
        button.addTarget(self, action: #selector(tapEdit), for: .touchUpInside)
        button.tintColor = UIColor.createColor(light: .black, dark: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.menu = addMenuItems()
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func constraints() {
        [info, first,two,three,four, name, ageUser, statusLife, heightUser, editButton].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            info.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            info.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            
            editButton.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            editButton.heightAnchor.constraint(equalToConstant: 25),
            editButton.widthAnchor.constraint(equalToConstant: 25),
            
            first.topAnchor.constraint(equalTo: info.bottomAnchor,constant: 10),
            first.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            
            two.topAnchor.constraint(equalTo: first.bottomAnchor,constant: 10),
            two.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
        
            three.topAnchor.constraint(equalTo: two.bottomAnchor,constant: 10),
            three.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            
            four.topAnchor.constraint(equalTo: three.bottomAnchor,constant: 10),
            four.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            four.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            name.topAnchor.constraint(equalTo: info.bottomAnchor,constant: 10),
            name.centerYAnchor.constraint(equalTo: first.centerYAnchor),
            name.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            
            ageUser.topAnchor.constraint(equalTo: name.bottomAnchor,constant: 10),
            ageUser.centerYAnchor.constraint(equalTo: two.centerYAnchor),
            ageUser.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
        
            statusLife.topAnchor.constraint(equalTo: ageUser.bottomAnchor,constant: 10),
            statusLife.centerYAnchor.constraint(equalTo: three.centerYAnchor),
            statusLife.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10),
            
            heightUser.topAnchor.constraint(equalTo: statusLife.bottomAnchor,constant: 10),
            heightUser.centerYAnchor.constraint(equalTo: four.centerYAnchor),
            heightUser.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10)
        ])
    }
    
    @objc func tapEdit() {
        delegate?.tapOpenEditInfo()
    }
    
    private func addMenuItems() -> UIMenu {
        let changeInfo = UIAction(title: "Редактировать инфо",image: UIImage(systemName: "person.fill.viewfinder")) { _ in
            self.delegate?.tapEditInfo()
        }
    
        let menu = UIMenu(title: "Выберите действие", children: [changeInfo])
        return menu
    }
    
    func configureMain(user: User?) {
        name.text = user?.name
        ageUser.text = user?.age
        statusLife.text = user?.lifeStatus
        heightUser.text = user?.height
    }
}
