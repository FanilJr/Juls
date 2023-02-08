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
    var usersString = [String]()
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
        flowLayout.itemSize = CGSize(width: 100, height: 100)
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
        tabBarController?.tabBar.isHidden = false
        title = "Профиль"
        setupTableView()
        imagePicker.delegate = self
        messagePostViewController.delegatePost = self
        fetchUser()
        refreshController.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let status = UserDefaults.standard.object(forKey: "status") as? String
        if let statusDisplay = status {
            self.header?.statusLabel.text = statusDisplay
        }
        let username = UserDefaults.standard.object(forKey: "username") as? String
        if let usernameDisplay = username {
            self.header?.nickNameLabel.text = usernameDisplay
        }
        let name = UserDefaults.standard.object(forKey: "name") as? String
        if let nameDisplay = name {
            self.mainCollection.name.text = nameDisplay
        }
    }
    
    @objc func didTapRefresh() {
        self.posts.removeAll()
        self.usersId.removeAll()
        self.fetchUser()
        self.collectionView.reloadData()
        self.refreshController.endRefreshing()
    }
    
    func showFollowes() {
        MyFollowersUserViewController.show(self, users: usersId)
    }
    
    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
        
    func setupTableView() {
        [background, collectionView, spinnerView].forEach({ view.addSubview($0) })
            
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
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
            cell.checkIFollowing(user: self.user)
            cell.checkFollowMe(user: self.user)
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
            header?.delegate = self
            return header!
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            PostTableViewController.showPostTableViewController(self, post: posts[indexPath.row])
        default:
            print(indexPath.section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        switch indexPath.section {
        case 1:
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                
                let _ = UIAction(title: "Поделится", image: UIImage(systemName:"square.and.arrow.up.circle")) { _ in
                }
                let remove = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                    
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
                let menu = UIMenu(title: "", children: [remove])
                return menu
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
//        print(contentOffsetY)
        if contentOffsetY == 200 {
            
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
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
            let height = CGFloat(220)
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
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            DispatchQueue.main.async {
                self.user = user
                self.header?.user = user
                self.fetchPostsWithUser(user: user)
                print("Перезагрузка в ProfileViewController fetchUser")
            }
        }
    }
    
    func fetchUserWithReload() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.header?.user = user
            self.collectionView.reloadData()
        }
    }
    
    func fetchPostsWithUser(user: User) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        DispatchQueue.main.async {
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
                print("Перезагрузка в ProfileViewController fetchPostsWithUser")
            
            }) { error in
                print("Failed to fetch posts:", error)
                return
            }
        }
    }
    
    func saveChanges() {
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
                        Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["picture" : urlText]) { error, ref in
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
    //MARK: Отправка поста
    func saveToDatabaseWithImageUrl(imageUrl: String) {
        
        print("PUSH PUSH PUSH")
        
        guard let postImage = messagePostViewController.customImage.image else { return }
        guard let caption = messagePostViewController.customTextfield.text else { return }
        
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
        tabBarController?.tabBar.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.posts = []
            self.fetchUser()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.messagePostViewController.customImage.image = nil
            self.messagePostViewController.customTextfield.text = ""
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
        let storedImage = Storage.storage().reference().child("posts").child(imageName)

        if let uploadData = messagePostViewController.customImage.image?.jpegData(compressionQuality: 0.3) {
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

extension ProfileViewController: StretchyDelegate {
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
            UserDefaults.standard.set(header?.statusLabel.text, forKey: "status")
            if let urlText = header?.statusLabel.text {
                
                Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["status" : urlText]) { error, ref in
                    if let error {
                        print(error)
                        return
                    }
                    print("succes download Status in Firebase Library")
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
                ["username","status","age","life status","name","height"].forEach { UserDefaults.standard.removeObject(forKey: $0)}
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
    
    func getUsersFollowMe() {
        guard let user = user else { return }
        FollowersUsersWithMeController.showUsers(self, user: user)
    }
    
    func getUsersIFollow() {
        guard let user = user else { return }
        MyFollowersUserViewController.showUsers(self, user: user)
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
