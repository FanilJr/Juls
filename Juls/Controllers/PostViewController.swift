//
//  PostViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 26.01.2023.
//

import Foundation
import UIKit
import Firebase

class PostTableViewController: UIViewController {
    
    var post: Post?
    var juls = JulsView()
    var refreshController = UIRefreshControl()
    var postsKeyArray = [String]()
    
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
        tableView.refreshControl = refreshController
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = juls
        navigationController?.navigationBar.isHidden = false
        refreshController.attributedTitle = NSAttributedString(string: "Обновление")
        refreshController.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        layout()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func didTapRefresh() {
        updatePost(post: post)
        refreshController.endRefreshing()
    }
    
    func updatePost(post: Post?) {
        // added methode update post...
    }
    
    static func showPostTableViewController(_ viewController: UIViewController, post: Post) {
        let ac = PostTableViewController()
        ac.post = post
        viewController.navigationController?.pushViewController(ac, animated: true)
    }

    
    func layout() {
        [background,tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension PostTableViewController: UITableViewDelegate {
    
}

extension PostTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = .clear
        cell.configureTable(post: self.post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
