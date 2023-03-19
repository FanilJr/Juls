//
//  PostViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 26.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol PostViewControllerDelegate: AnyObject {
    func reloadTable()
}

class PostTableViewController: UIViewController {
    
    weak var delegate: PostViewControllerDelegate?
    
    var cgfloatTabBar: CGFloat?
    var post: Post?
    var juls = JulsView()
    var commentArray = [String]()
    let sheetComments = CommentsSheetViewController()
    
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
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPost()
        view.backgroundColor = .systemGray
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.sheetComments.dismiss(animated: true)
    }
    
    private func setupDidLoad() {
        setupNavButton()
        layout()
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationItem.largeTitleDisplayMode = .never
        let height = self.tabBarController?.tabBar.frame.height
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.frame.origin.y += height!
            self.cgfloatTabBar = self.tabBarController?.tabBar.frame.origin.y
        }
    }
    
    private func setupWillAppear() {
        let height = self.tabBarController?.tabBar.frame.height
        if self.tabBarController?.tabBar.frame.origin.y != self.cgfloatTabBar {
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.frame.origin.y += height!
//                self.tabBarController?.tabBar.isHidden = true
            }
        }
    }
    
    
    private func setupNavButton() {
        if post?.user.uid == Auth.auth().currentUser?.uid {
            let deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteAction))
            deleteButton.tintColor = UIColor.createColor(light: .red, dark: .red)
            navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    @objc func deleteAction() {
        let alertController = UIAlertController(title: "Удалить пост", message: "Вы действительно хотите удалить пост?", preferredStyle: .alert)
        let alertDelete = UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            Database.database().deletePost(withUID: self.post?.user.uid ?? "", postId: self.post?.id ?? "")
            self.navigationController?.popViewController(animated: true)
            self.delegate?.reloadTable()
        })
        let alertCancel = UIAlertAction(title: "Отмена", style: .cancel)
        [alertCancel,alertDelete].forEach { alertController.addAction($0) }
        present(alertController, animated: true)
    }
    
    
    func fetchPost() {
        guard let stringTile = post?.message else { return }
        self.title = stringTile
        guard let imageUrl = self.post?.imageUrl else { return }
        self.imageBack.loadImage(urlString: imageUrl)
    }
    
    static func showPost(_ viewController: UIViewController, post: Post) {
        let ac = PostTableViewController()
        ac.post = post
        viewController.navigationController?.pushViewController(ac, animated: true)
    }

    func layout() {
        [imageBack,blureForCell,tableView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageBack.topAnchor.constraint(equalTo: view.topAnchor),
            imageBack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blureForCell.topAnchor.constraint(equalTo: view.topAnchor),
            blureForCell.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blureForCell.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blureForCell.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
        cell.post = self.post
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PostTableViewController: CommentDelegate {
    
    func didTapLike(for cell: PostTableViewCell) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        guard let postId = self.post?.id else { return }
        if var post = self.post {
            if post.hasLiked == false {
            
                let values = [uid : 1]
                Database.database().reference().child("likes").child(postId).updateChildValues(values) { [self] error, _ in
                    if let error {
                        print(error)
                        return
                    }
                    print("successfully liked post:", post.message)
                    post.hasLiked = !post.hasLiked
                    post.likes = post.likes + 1
                    self.post = post
                    print(post.likes)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.fetchPost()
                }
            } else {
                Database.database().reference().child("likes").child(postId).child(uid).removeValue { (err, _) in
                    if let err = err {
                        print("Failed to unlike post:", err)
                        return
                    }
                    post.hasLiked = !post.hasLiked
                    post.likes = post.likes - 1
                    self.post = post
                    print(post.likes)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    self.fetchPost()
                }
            }
        }
    }
    
    func didtapImageComment() {
        CommentViewController.showComment(self, post: post)
    }
    
    func didTapComment() {
        sheetComments.post = self.post
        if let sheet = sheetComments.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        present(sheetComments, animated: true)
    }
}
