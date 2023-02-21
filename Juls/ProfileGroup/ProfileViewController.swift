//
//  ProfileViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import AVFoundation

class ProfileViewController: UIViewController {
    
    var user: User?
    var userId: String?
    var usersId = [User]()
    var experementUser = [User]()
    var posts = [Post]()
    var postsKeyArray = [String]()
    var iFollowUsers = [String]()
    var usersString = [String]()
    var usersFollowMe = [String]()
    var countUser = [String]()
    var cgfloatTabBar: CGFloat?
    var postsCount = [String]()
    private var refreshController = UIRefreshControl()
    private let messagePostViewController = MessagePostViewController()
    private let settingsViewController = SettingsViewController()
    private let viewModel: ProfileViewModel
    private let saveView = SaveView()
    private let infoView = InfoView()
    private let imagePicker = UIImagePickerController()
    private var currentImage: UIImageView?
    private let headerCollection = StretchyCollectionHeaderView()
    private var header: StretchyCollectionHeaderView?
    let mainCollection = MainCollectionViewCell()
    
    
    let systemSoundID: SystemSoundID = 1016
    let systemSoundID2: SystemSoundID = 1018
    
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
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private let spinnerViewForPost: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    var blure: UIVisualEffectView = {
        let bluereEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blure = UIVisualEffectView()
        blure.effect = bluereEffect
        blure.translatesAutoresizingMaskIntoConstraints = false
        blure.clipsToBounds = true
        blure.alpha = 0
        return blure
    }()
    
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
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = 1.0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.refreshControl = refreshController
        collectionView.register(StretchyCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StretchyCollectionHeaderView")
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "MainCollectionViewCell")
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotosCollectionViewCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWillAppear()
    }
    
    private func setupDidLoad() {
        cgfloatTabBar = tabBarController?.tabBar.frame.origin.y
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
        refreshController.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        setupTableView()
        imagePicker.delegate = self
        messagePostViewController.delegatePost = self
    }
    
    private func setupWillAppear() {
        let height = tabBarController?.tabBar.frame.height
        if tabBarController?.tabBar.frame.origin.y != cgfloatTabBar {
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.frame.origin.y -= height!
            }
        }
        navigationController?.hidesBarsOnSwipe = false
        tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @objc func didTapRefresh() {
        self.posts.removeAll()
        self.usersId.removeAll()
        self.usersFollowMe.removeAll()
        self.countUser.removeAll()
        self.iFollowUsers.removeAll()
        self.postsCount.removeAll()
        self.fetchUser()
        self.collectionView.reloadData()
        self.refreshController.endRefreshing()
    }

    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
        
    func setupTableView() {
        [background, imageBack, blureForCell, collectionView, spinnerView].forEach({ view.addSubview($0) })
            
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
                
            collectionView.topAnchor.constraint(equalTo: background.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: background.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: background.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            
            spinnerView.topAnchor.constraint(equalTo: collectionView.topAnchor,constant: 300),
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension ProfileViewController: UICollectionViewDelegate {
}

extension ProfileViewController: UICollectionViewDataSource {
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
            cell.configureMain(user: self.user)
            cell.postsButton.setTitle("\(postsCount.count)", for: .normal)
            cell.iFollowButton.setTitle("\(iFollowUsers.count)", for: .normal)
            cell.followMeButton.setTitle("\(countUser.count)", for: .normal)
            cell.delegate = self
            cell.backgroundColor = .clear
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotosCollectionViewCell", for: indexPath) as! PhotosCollectionViewCell
            cell.configureCell(post: posts[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StretchyCollectionHeaderView", for: indexPath) as? StretchyCollectionHeaderView
//            header?.user = self.user
            header?.delegate = self
            return header!
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            let postVC = PostTableViewController()
            postVC.post = posts[indexPath.row]
            navigationController?.pushViewController(postVC, animated: true)
        default:
            print(indexPath.section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        var indexPaths = posts[indexPath.row]
            switch indexPath.section {
            case 1:
                let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                    let _ = UIAction(title: "Нравится",  image: UIImage(systemName: "heart")) { _ in
                        //MARK: Работает но только в моем профиле
                        let uid = self.user?.uid
                        let values = [uid: indexPaths.hasLiked == true ? 0 : 1]
                        DispatchQueue.main.async {
                            Database.database().reference().child("likes").child(indexPaths.id ?? "").updateChildValues(values) { error, _ in
                                if let error {
                                    print(error)
                                    return
                                }
                                print("successfully liked post")
                                indexPaths.hasLiked = !indexPaths.hasLiked
                            }
                        }
                    }
                    
                    let shared = UIAction(title: "Поделится", image: UIImage(systemName:"square.and.arrow.up")) { _ in
                        let avc = UIActivityViewController(activityItems: [self.posts[indexPath.row].user.username as Any, self.posts[indexPath.row].message as Any], applicationActivities: nil)
                        self.present(avc, animated: true)
                    }
                    let remove = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                        let alert = UIAlertController(title: "", message: "Вы точно хотите удалить?", preferredStyle: .alert)
                        let removeAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
                            guard let uid = self.user?.uid else { return }
                            self.getAllKaysPost()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                Database.database().reference().child("posts").child(uid).child(self.postsKeyArray[indexPath.item]).removeValue()
                                self.posts.remove(at: indexPath.item)
                                self.collectionView.deleteItems(at: [indexPath])
                                self.postsKeyArray = []
                                self.collectionView.reloadData()
                            })
                        }
                        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
                            self.dismiss(animated: true)
                        }
                        [removeAction, cancelAction].forEach { alert.addAction($0) }
                        self.present(alert, animated: true)
                    }
                    if Auth.auth().currentUser?.uid == self.user?.uid {
                        let menu = UIMenu(title: "", children: [shared,remove])
                        return menu
                    } else {
                        let menu = UIMenu(title: "", children: [shared])
                        return menu
                    }
                })
                return configuration
            default:
                return nil
        }
    }
    
    func getAllKaysPost() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("posts").child(uid).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                let snap = child as! Firebase.DataSnapshot
                let key = snap.key
                self.postsKeyArray.insert(key, at: 0)
            }
        })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY == 200 {      
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: self.collectionView.frame.size.width, height: 540)
        default:
            return CGSize()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
            
        case 0:
            let width = collectionView.bounds.width
            let height = CGFloat(220)
            return CGSize(width: width, height: height)
            
        case 1:
            let width = (view.frame.width - 3) / 3
            return CGSize(width: width, height: width)
            
        default:
            return CGSize()
        }
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        if currentImage == messagePostViewController.customImage {
            currentImage?.image = pickedImage
            dismiss(animated: true)
            if let sheet = messagePostViewController.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            present(messagePostViewController, animated: true)
            
        } else if currentImage == header?.userImage {
            currentImage?.image = pickedImage
            waitingSpinnerEnable(true)
            dismiss(animated: true)
            self.saveChanges()
            print("header в имейдж пикер релоад")
        }
    }
}

//MARK: FETCH USER, FETCH POSTS, SAVE CHANGE
extension ProfileViewController {
    
    func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        Database.fetchUserWithUID(uid: uid) { user in
            DispatchQueue.main.async {
                self.user = user
                self.header?.user = user
                self.imageBack.loadImage(urlString: user.picture)
                self.checkFollowMe(user: user)
                self.checkPosts(user: user)
                self.checkIFollowing(user: user)
                self.fetchPostsWithUser(user: user)
            }
        }
    }
    
    func fetchPostsWithUser(user: User) {
        let ref = Database.database().reference().child("posts").child(user.uid)
        DispatchQueue.main.async {
            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionaries = snapshot.value as? [String: Any] else { return }
                
                dictionaries.forEach { key, value in
                    guard let dictionary = value as? [String: Any] else { return }
                    var post = Post(user: user, dictionary: dictionary)
                    post.id = key
                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { snapshot in
                        if let value = snapshot.value as? Int, value == 1 {
                            post.hasLiked = true
                        } else {
                            post.hasLiked = false
                        }
                        self.posts.append(post)
                        self.posts.sort { p1, p2 in
                            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                        }
                        self.collectionView.reloadData()
                    })
                }
                print("Перезагрузка в ProfileViewController fetchPostsWithUser")
            }) { error in
                print("Failed to fetch posts:", error)
            }
        }
    }
    
    func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let imageName = NSUUID().uuidString
        let storedImage = Storage.storage().reference().child("profile_image").child(imageName)

        if let uploadData = header?.userImage.image?.jpegData(compressionQuality: 0.3) {
            storedImage.putData(uploadData, metadata: nil) { metadata, error in
                if let error {
                    print("error upload", error)
                    return
                }
                storedImage.downloadURL(completion: { url, error in
                    if let error {
                        print(error)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        Database.database().reference().child("users").child(userId).updateChildValues(["picture" : urlText]) { error, ref in
                            if let error {
                                print(error)
                                return
                            }
                            print("succes download Photo in Firebase Library")
                            self.waitingSpinnerEnable(false)
                            self.view.addSubview(self.saveView)
                            self.posts.removeAll()
                            self.fetchUser()
                            NSLayoutConstraint.activate([
                                self.saveView.topAnchor.constraint(equalTo: self.collectionView.topAnchor,constant: 300),
                                self.saveView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                self.saveView.heightAnchor.constraint(equalToConstant: 150),
                                self.saveView.widthAnchor.constraint(equalToConstant: 150)
                            ])
                            UIView.animate(withDuration: 0.7) {
                                self.saveView.alpha = 1
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.1) {
                                UIView.animate(withDuration: 1) {
                                    self.saveView.alpha = 0
                                }
                            }
                        }
                    }
                })
            }
        }
    }
    
    func checkIFollowing(user: User?) {
        guard let userId = user?.uid else { return }
        DispatchQueue.main.async {
            Database.database().reference().child("following").child(userId).observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! Firebase.DataSnapshot
                    let key = snap.key
                    self.iFollowUsers.append(key)
                }
                self.collectionView.reloadData()
            })
        }
    }
    
    func checkPosts(user: User?) {
        guard let uid = user?.uid else { return }
        DispatchQueue.main.async {
            Database.database().reference().child("posts").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! Firebase.DataSnapshot
                    let key = snap.key
                    self.postsCount.append(key)
                }
                self.collectionView.reloadData()
            })
        }
    }
    
    func checkFollowMe(user: User?) {
        guard let userId = user?.uid else { return }
        DispatchQueue.main.async {
            let ref = Database.database().reference().child("following")
            ref.observeSingleEvent(of: .value, with: { snapshot in
                for child in snapshot.children {
                    let snap = child as! Firebase.DataSnapshot
                    let key = snap.key
                    if key != userId {
                        self.usersFollowMe.append(key)
                    }
                }
                for i in self.usersFollowMe {
                    let ref = Database.database().reference().child("following").child(i)
                    ref.observeSingleEvent(of: .value, with: { snapshot in
                        for child in snapshot.children {
                            let snap = child as! Firebase.DataSnapshot
                            let key = snap.key
                            if key == self.user?.uid {
                                self.countUser.append(i)
                            }
                        }
                    })
                    self.collectionView.reloadData()
                }
            })
        }
    }
    //MARK: Отправка поста
    func saveToDatabaseWithImageUrl(imageUrl: String) {
        
        print("PUSH PUSH PUSH")
        
        guard let postImage = messagePostViewController.customImage.image else { return }
        guard let caption = messagePostViewController.customTextfield.text else { return }
        DispatchQueue.main.async {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let userPostRef = Database.database().reference().child("posts").child(uid)
            
            let ref = userPostRef.childByAutoId()
            
            let values = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]
            
            ref.updateChildValues(values) { error, ref in
                if let error {
                    print("Error", error)
                }
                print("succes upload Post in Firebase")
            }
            self.messagePostViewController.waitingSpinnerPostEnable(false)
            self.messagePostViewController.sendPostButton.setTitle("Отправить", for: .normal)
            self.messagePostViewController.sendPostButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
            
            AudioServicesPlaySystemSound(self.systemSoundID2)
            self.dismiss(animated: true)
            self.tabBarController?.tabBar.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.posts = []
                self.usersId.removeAll()
                self.usersFollowMe.removeAll()
                self.countUser.removeAll()
                self.iFollowUsers.removeAll()
                self.postsCount.removeAll()
                self.fetchUser()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.messagePostViewController.customImage.image = nil
                self.messagePostViewController.customTextfield.text = ""
            }
        }
    }
}

//MARK: Редактирование информации пользователя
extension ProfileViewController: InfoDelegate {
    
    func cancelSave() {
        UIView.animate(withDuration: 0.8, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -790)
            self.blure.alpha = 0
        })
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.infoView.removeFromSuperview()
            self.blure.removeFromSuperview()
            self.collectionView.reloadData()
        }
    }
    
    func saveInfo() {
        print("tut save info")
        if let urlText = infoView.name.text {
            Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["name" : urlText]) { error, ref in
                if let error {
                    print(error)
                    return
                }
                print("succes download name in Firebase Library")
            }
        }
        if let urlText = infoView.secondName.text {
            Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["secondName" : urlText]) { error, ref in
                if let error {
                    print(error)
                    return
                }
                print("succes download secondname in Firebase Library")
            }
        }
        if let urlText = infoView.age.text {
            Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["age" : urlText]) { error, ref in
                if let error {
                    print(error)
                    return
                }
                print("succes download age in Firebase Library")
            }
        }
        if let urlText = infoView.height.text {
            Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["height" : urlText]) { error, ref in
                if let error {
                    print(error)
                    return
                }
                print("succes download height in Firebase Library")
            }
        }
        
        if let urlText = infoView.statusLife.text {
            Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["life status" : urlText]) { error, ref in
                if let error {
                    print(error)
                    return
                }
                print("succes download height in Firebase Library")
            }
        }
        
        UIView.animate(withDuration: 0.8, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -790)
            self.blure.alpha = 0
        })
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.infoView.removeFromSuperview()
            self.blure.removeFromSuperview()
            self.posts.removeAll()
            self.usersId.removeAll()
            self.usersFollowMe.removeAll()
            self.countUser.removeAll()
            self.iFollowUsers.removeAll()
            self.postsCount.removeAll()
            self.fetchUser()
        }
    }
}

//MARK: PostViewDelegate : Отправка поста sheetController
extension ProfileViewController: MessagePostDelegate {
    func closedPostPostDelegate() {
        messagePostViewController.customTextfield.text = ""
        messagePostViewController.customImage.image = nil
        dismiss(animated: true)
    }
    
    func presentPostImagePicker() {
        dismiss(animated: true)
        currentImage = messagePostViewController.customImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.present(self.imagePicker, animated: true)
        })
    }

    func pushPostDelegate() {
        guard let caption = messagePostViewController.customTextfield.text, caption.count > 0 else { return }
        let imageName = NSUUID().uuidString
        DispatchQueue.main.async {
            let storedImage = Storage.storage().reference().child("posts").child(imageName)
            
            if let uploadData = self.messagePostViewController.customImage.image?.jpegData(compressionQuality: 0.3) {
                storedImage.putData(uploadData, metadata: nil) { metadata, error in
                    if let error {
                        print("error upload", error)
                        return
                    }
                    storedImage.downloadURL(completion: { url, error in
                        if let error {
                            print(error)
                            return
                        }
                        guard let imageURL = url?.absoluteString else { return }
                        print("succes download Photo in Firebase Library")
                        self.saveToDatabaseWithImageUrl(imageUrl: imageURL)
                    })
                }
            }
            self.collectionView.reloadData()
        }
    }
}

extension ProfileViewController: StretchyDelegate {
    func backUp() {
        navigationController?.popViewController(animated: true)
    }
    
    func setupSettings() {
        if let sheet = settingsViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        present(settingsViewController, animated: true)
    }
    
    func showAlbum() {
        viewModel.send(.showPhotosVc)
    }
    
    func addStatus() {
        let alert = UIAlertController(title: "Введите статус", message: "", preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "Ok", style: .default)  { [self] _ in
            let text = alert.textFields?.first?.text
            header?.statusLabel.text = text
            AudioServicesPlaySystemSound(self.systemSoundID)
            if let urlText = header?.statusLabel.text {
                DispatchQueue.main.async {
                    Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["status" : urlText]) { error, ref in
                        if let error {
                            print(error)
                            return
                        }
                        print("succes download Status in Firebase Library")
                    }
                }
            }
        }
        let alertCancel = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addTextField()
        [alertOK,alertCancel].forEach { alert.addAction($0) }
        present(alert, animated: true)

    }
    
    func presentImagePickerForUser() {
        print("Проверка presentImage")
        currentImage = header?.userImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.present(self.imagePicker, animated: true)
        })
    }
    
    func logOut() {
        print("Выход из аккаунта")
        let alert = UIAlertController(title: "Выход из аккаунта", message: "Вы уверены?", preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "Выйти", style: .destructive)  { [self] _ in
            do {
                try Auth.auth().signOut()
                viewModel.send(.showLoginVc)
            } catch {
                print("error")
            }
        }
        let alertCancel = UIAlertAction(title: "Отмена", style: .default)
        [alertOK,alertCancel].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func addPostInCollection() {
        if let sheet = messagePostViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.largestUndimmedDetentIdentifier = .medium
            sheet.prefersGrabberVisible = true
        }
        present(messagePostViewController, animated: true)
    }
}

extension ProfileViewController: MainCollectionDelegate {
    
    func tapPosts(for cell: MainCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.top, animated: true)
    }
    
    func getUsersFollowMe() {
        guard let user = user else { return }
        let followMeUsers = FollowersUsersWithMeController()
        followMeUsers.user = user
        navigationController?.pushViewController(followMeUsers, animated: true)
    }
    
    func getUsersIFollow() {
        guard let user = user else { return }
        let iFollowUsers = MyFollowersUserViewController()
        iFollowUsers.user = user
        navigationController?.pushViewController(iFollowUsers, animated: true)
    }
    
    func editInfo() {
        view.addSubview(blure)
        view.addSubview(infoView)
        infoView.delegateInfo = self
            
        NSLayoutConstraint.activate([
            blure.topAnchor.constraint(equalTo: view.topAnchor),
            blure.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blure.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blure.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
            infoView.topAnchor.constraint(equalTo: view.topAnchor,constant: -680),
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50),
            infoView.heightAnchor.constraint(equalToConstant: 680),
        ])
        
        UIView.animate(withDuration: 0.8, animations: {
            self.infoView.transform = CGAffineTransform(translationX: 0, y: 790)
            self.infoView.alpha = 1
            self.blure.alpha = 1
        })
        tabBarController?.tabBar.isHidden = true
    }
}
