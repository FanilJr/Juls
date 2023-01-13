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
    var header = ProfileFriendsHeaderView()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "sunset")
        back.clipsToBounds = true
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(MainFriendsTableViewCell.self, forCellReuseIdentifier: "MainFriendsTableViewCell")
        tableView.register(PostFriendsTableViewCell.self, forCellReuseIdentifier: "PostFriendsTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        title = user?.username
        layout()
        tableView.delegate = self
        tableView.dataSource = self
        header.delegate = self
        header.user = user
        fetchPostsWithUser(user: user!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        self.tableView.reloadData()
        print("reload friendscontroller")
    }
    
    static func show(_ viewController: UIViewController, user: User) {
        let ac = ProfileFriendsViewController()
        ac.user = user
        viewController.navigationController?.pushViewController(ac, animated: true)
    }
    
    func layout() {
        [background, tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: background.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: background.bottomAnchor)
        ])
    }
}

extension ProfileFriendsViewController: UITableViewDataSource {
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainFriendsTableViewCell", for: indexPath) as!
            MainFriendsTableViewCell
            cell.backgroundColor = .clear
            cell.first.text = "Имя: "
            cell.two.text = "Возраст: "
            cell.three.text = "Семейное положение: "
            cell.four.text = "Рост: "
            cell.five.text = "Привычки: "
            
            //MARK: Получаем реальные данные ячейки пользователя (с обновлением в реальном времени)
            if let uid = user?.uid {
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    self.user = User(uid: uid, dictionary: dictionary)
                    
                    DispatchQueue.main.async {
                        cell.name.text = self.user?.name
                        cell.ageUser.text = self.user!.age
                        cell.statusLife.text = self.user?.lifeStatus
                        cell.heightUser.text = self.user!.height
                    }
                    
                }) { err in
                    print("Failet to setup user", err)
                }
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostFriendsTableViewCell", for: indexPath) as! PostFriendsTableViewCell
            cell.backgroundColor = .clear
            cell.post = posts[indexPath.item]
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.scrollViewDidScroll(scrollView: tableView)
    }
}

extension ProfileFriendsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        switch section {
        case 0:
            return UITableView.automaticDimension
        case 1:
            return 0
        case 2:
            return 0
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ProfileFriendsViewController: HeaderFriendsDelegate {
    func backUp() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileFriendsViewController {
    
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
        self.tableView.reloadData()
        }) { error in
            print("Failed to fetch posts:", error)
            return
        }
    }
}
