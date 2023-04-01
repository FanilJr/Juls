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
import MobileCoreServices
import UniformTypeIdentifiers

class ProfileViewController: UIViewController {
    
    var user: User?
    var userId: String?
    var rating: Raiting?
    var posts = [Post]()
    var postsKeyArray = [String]()
    var iFollowUsers: Int?
    var followMeUsers: Int?
    var postsCount: Int?
    var cgfloatTabBar: CGFloat?
    var player: AVPlayer?
    
    private var refreshController = UIRefreshControl()
    private let messagePostViewController = MessagePostViewController()
    private let viewModel: ProfileViewModel
    private let saveView = SaveView()
    private let infoView = InfoView()
    private let imagePicker = UIImagePickerController()
    private let filePicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.mp3], asCopy: true)
    private var currentImage: UIImageView?
    private var header: StretchyCollectionHeaderView?
    private let ratingVC = RatingViewController()
    
    let systemSoundID: SystemSoundID = 1016
    let systemSoundID2: SystemSoundID = 1018

    private lazy var titleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = #colorLiteral(red: 0.1758851111, green: 0.5897727013, blue: 0.9195605516, alpha: 1)
        imageView.image = UIImage(systemName: "checkmark.seal.fill")
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(openInfoForOfficial))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gesture)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let newMessage: UILabel = {
        let new = UILabel(frame: CGRect(x: 45, y: 15, width: 20, height: 20))
        new.font = UIFont(name: "Futura-Bold", size: 14)
        return new
    }()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private let spinnerViewForPutTrack: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
        activityView.color = .black
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private let titleSpinner: UILabel = {
        let title = UILabel()
        title.text = "Дождитесь окончания загрузки"
        title.textColor = UIColor.createColor(light: .black, dark: .white)
        title.shadowColor = UIColor.createColor(light: .gray, dark: .gray)
        title.font = UIFont(name: "Futura-Bold", size: 20)
        title.shadowOffset = CGSize(width: 1, height: 1)
        title.isHidden = true
        title.clipsToBounds = true
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
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
        view.backgroundColor = .systemGray6
        cgfloatTabBar = tabBarController?.tabBar.frame.origin.y
        
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        let height = self.tabBarController?.tabBar.frame.height
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        if self.tabBarController?.tabBar.frame.origin.y != self.cgfloatTabBar {
            UIView.animate(withDuration: 0.3) {
                self.tabBarController?.tabBar.frame.origin.y -= height!
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messagePostViewController.view.endEditing(true)
        ratingVC.view.endEditing(true)
        showOrAlpha(object: self.titleImage, false)
        showOrAlpha(object: self.newMessage, false)
        self.header?.progressBar.value = 0.0
        self.header?.progressBar.alpha = 0.0
        self.stop()
        self.header?.playSongButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showOrAlpha(object: self.titleImage, true)
        showOrAlpha(object: self.newMessage, true)
    }
    
    @objc func didTapRefresh() {
        self.fetchUser()
        print("refresh friend Profile")
    }
    
    @objc func openInfoForOfficial() {
        let alertController = UIAlertController(title: "Подтверждающая галочка", message: "Статус: *Известная личность*", preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(alertOk)
        present(alertController, animated: true)
    }
    
    @objc func pushMessageFriendController() {
        let chatVC = ChatViewController()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().fetchUser(withUID: uid) { user in
            DispatchQueue.main.async {
                chatVC.user = user
                chatVC.userFriend = self.user
                self.navigationController?.pushViewController(chatVC, animated: true)
            }
        }
    }
    
    @objc func pushMessageController() {
        let messageVC = MessagesViewController()
        messageVC.user = user
        navigationController?.pushViewController(messageVC, animated: true)
    }
    
    @objc func presentUserFriendRating() {
        ratingVC.rating = rating
        if let sheet = ratingVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = true
        }
        present(ratingVC, animated: true)
    }
        
    func setupTableView() {
        filePicker.delegate = self
        imagePicker.delegate = self
        messagePostViewController.delegate = self
        refreshController.addTarget(self, action: #selector(didTapRefresh), for: .valueChanged)
        fetchUser()
        loadDatabase()
        [collectionView, spinnerView,titleSpinner,spinnerViewForPutTrack].forEach({ view.addSubview($0) })
            
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinnerView.topAnchor.constraint(equalTo: collectionView.topAnchor,constant: 300),
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleSpinner.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -50),
            titleSpinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            spinnerViewForPutTrack.topAnchor.constraint(equalTo: titleSpinner.bottomAnchor,constant: 10),
            spinnerViewForPutTrack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
            waitingSpinnerEnable(activity: self.spinnerView, active: true)
            dismiss(animated: true)
            self.saveChanges()
            print("header в имейдж пикер релоад")
        }
    }
}

//MARK: FETCH USER, FETCH POSTS, SAVE CHANGE
extension ProfileViewController {
    
    private func moveAndResizeImage(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Const.NavBarHeightSmallState
            let heightDifferenceBetweenStates = (Const.NavBarHeightLargeState - Const.NavBarHeightSmallState)
            return delta / heightDifferenceBetweenStates
        }()
        
        let factor = Const.ImageSizeForSmallState / Const.ImageSizeForLargeState
        
        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()
        
        // Value of difference between icons for large and small states
        let sizeDiff = Const.ImageSizeForLargeState * (1.0 - factor) // 8.0
        
        let yTranslation: CGFloat = {
            /// This value = 14. It equals to difference of 12 and 6 (bottom margin for large and small states). Also it adds 8.0 (size difference when the image gets smaller size)
            let maxYTranslation = Const.ImageBottomMarginForLargeState - Const.ImageBottomMarginForSmallState + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Const.ImageBottomMarginForSmallState + sizeDiff))))
        }()
        
        let xTranslation: CGFloat?
        
        guard let LargeMyString = title else { return }
        var stringWidth = 0.0
        if let font = UIFont(name: "Futura-Bold", size: 31) {
            stringWidth = LargeMyString.size(withAttributes: [.font: font]).width + 23
        }

        let fixedNumber = 150 // фиксированное число
        let coeffs = 1 - (Double(fixedNumber) / stringWidth) // коэффициент обратной пропорциональности
        let someNumber = 110 // какое-то произвольное число
        let result = someNumber - Int(coeffs * Double(someNumber) * 1.7)// число, уменьшающееся с увеличением stringWidth
        let CGFloatResult = CGFloat(result)
        xTranslation = max(0, CGFloatResult - coeff * CGFloatResult)
        
        titleImage.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation!, y: yTranslation)
    }
    
    func fetchTick() {
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.addSubview(titleImage)
        guard let LargeMyString = title else { return }
        var stringWidth = 0.0
        if let font = UIFont(name: "Futura-Bold", size: 31) {
            stringWidth = LargeMyString.size(withAttributes: [.font: font]).width + 23
        }
        
        NSLayoutConstraint.activate([
            titleImage.leadingAnchor.constraint(equalTo: navBar.leadingAnchor,constant: stringWidth),
            titleImage.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            titleImage.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            titleImage.widthAnchor.constraint(equalTo: titleImage.heightAnchor)
        ])
    }
    
    func presentRating() {
        ratingVC.rating = rating
        if let sheet = ratingVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = true
        }
        present(ratingVC, animated: true)
    }

    func deleteMusic() {
        let alert = UIAlertController(title: "Удалить песню", message: "Вы уверены?", preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "Удалить", style: .destructive)  { [self] _ in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let song = user?.loveSong else { return }
            Storage.storage().reference().child("songs/\(uid)").child(song).delete { error in
                if let error {
                    print(error)
                    return
                }
                Database.database().reference().child("users").child(uid).child("loveSong").removeValue { error, _ in
                    if let error {
                        print(error)
                        return
                    }
                    self.fetchUser()
                    print("succes delete Music")
                }
            }
        }
        let alertCancel = UIAlertAction(title: "Отмена", style: .default)
        [alertOK,alertCancel].forEach { alert.addAction($0) }
        present(alert, animated: true)
    }
    
    func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.database().fetchUser(withUID: uid) { user in
            self.user = user
            self.title = user.username
            self.setupNavigationButton(user: user)
            self.header?.user = user
            
            if user.uid == uid {
                Database.database().updateMessageInNavigationBar(userId: uid, navigation: self.navigationController!, label: self.newMessage)
            }
            if user.official {
                print(user.username, "- official status <Public person>")
                self.fetchTick()
            }
            
            Database.database().fetchRaitingUser(withUID: uid) { raiting in
                self.rating = raiting
            }
            Database.database().fetchAllPosts(withUID: uid) { posts in
                DispatchQueue.main.async {
                    self.collectionView.refreshControl?.endRefreshing()
                    self.posts = posts
                    self.collectionView.reloadData()
                }
            } withCancel: { error in
                print(error)
            }
        }
    }
    
    private func loadDatabase() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
        
        Database.database().numberOfItemsForUser(withUID: uid, category: "posts") { count in
            self.postsCount = count
            
            var postRaiting = 0.0
            postRaiting = min(Double(count) * 0.05, 1.0)
            
            let values = ["postsRating": postRaiting]
            Database.database().reference().child("rating").child(uid).updateChildValues(values) { error, _ in
                if let error {
                    print(error)
                    return
                }
                self.collectionView.reloadData()
            }
        }
        Database.database().numberOfItemsForUser(withUID: uid, category: "followers") { count in
            self.followMeUsers = count
            
            var followers = 0.0
            followers = min(Double(count) * 0.01, 1.0)
            
            let values = ["followersRating": followers]
            Database.database().reference().child("rating").child(uid).updateChildValues(values) { error, _ in
                if let error {
                    print(error)
                    return
                }
                self.collectionView.reloadData()
            }
        }
        Database.database().numberOfItemsForUser(withUID: uid, category: "following") { count in
            self.iFollowUsers = count
            self.collectionView.reloadData()
        }
        Database.database().numberOfItemsForUser(withUID: uid, category: "YoulikeAcc") { count in
            var like = 0.0
            like = min(Double(count) * 0.01, 1.0)
            
            let values = ["likeYouUserAcc": like]
            Database.database().reference().child("rating").child(uid).updateChildValues(values) { error, _ in
                if let error {
                    print(error)
                    return
                }
            }
        }
        
        Database.database().numberOfItemsForUser(withUID: uid, category: "likeYourAcc") { count  in
            var like = 0.0
            like = min(Double(count) * 0.01, 1.0)
            
            let values = ["likeYourAcc": like]
            Database.database().reference().child("rating").child(uid).updateChildValues(values) { error, _ in
                if let error {
                    print(error)
                    return
                }
            }
        }
    }
    
    func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let imageName = NSUUID().uuidString
        let storedImage = Storage.storage().reference().child("profile_image").child(userId).child(imageName)
        
        if let uploadData = header?.userImage.image?.jpegData(compressionQuality: 0.1) {
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
                            waitingSpinnerEnable(activity: self.spinnerView, active: false)
                            self.view.addSubview(self.saveView)
                            self.didTapRefresh()
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
    
    func addStatus() {
        let alert = UIAlertController(title: "Введите статус", message: "", preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "Ok", style: .default)  { [self] _ in
            let text = alert.textFields?.first?.text
            AudioServicesPlaySystemSound(self.systemSoundID)
            if let urlText = text {
                DispatchQueue.main.async {
                    Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["status" : urlText]) { error, ref in
                        if let error {
                            print(error)
                            return
                        }
                        self.fetchUser()
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
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 25
            sheet.prefersGrabberVisible = true
        }
        present(messagePostViewController, animated: true)
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
            self.didTapRefresh()
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
        Database.database().createPost(withImage: messagePostViewController.customImage.image ?? UIImage(), caption: messagePostViewController.customTextfield.text) { error in
            if let error {
                print(error)
            }
            AudioServicesPlaySystemSound(self.systemSoundID2)
            self.messagePostViewController.waitingSpinnerPostEnable(false)
            self.messagePostViewController.sendPostButton.setTitle("Отправить", for: .normal)
            self.messagePostViewController.sendPostButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)

            
            UIView.animate(withDuration: 0.5, animations: {
                self.fetchUser()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.messagePostViewController.customImage.image = nil
                self.messagePostViewController.customTextfield.text = ""
            }
            self.dismiss(animated: true)
        }
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
            cell.postsButton.setTitle("\(postsCount ?? 0)", for: .normal)
            cell.iFollowButton.setTitle("\(iFollowUsers ?? 0)", for: .normal)
            cell.followMeButton.setTitle("\(followMeUsers ?? 0)", for: .normal)
            cell.delegate = self
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
            let postVC = PostTableViewController()
            postVC.post = posts[indexPath.row]
            postVC.rating = rating
            postVC.delegate = self
            self.navigationController?.pushViewController(postVC, animated: true)
            
        default:
            print(indexPath.section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        switch indexPath.section {
        case 1:
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
                let customImage = CustomImageView()
                customImage.loadImage(urlString: self.posts[indexPath.row].imageUrl)
                var sharedImage = UIImage()
                if let image = customImage.image {
                    sharedImage = image
                }
                
                let shared = UIAction(title: "Поделится", image: UIImage(systemName:"square.and.arrow.up")) { _ in
                    let avc = UIActivityViewController(activityItems: ["From JULS with LOVE:" as String, "@\(self.posts[indexPath.row].user.username) say" as String, self.posts[indexPath.row].message as String, sharedImage as UIImage], applicationActivities: nil)
                    self.present(avc, animated: true)
                }
                    
                if Auth.auth().currentUser?.uid == self.user?.uid {
                    let menu = UIMenu(title: "", children: [shared])
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
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResizeImage(for: height)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    var spacing: CGFloat { return 3 }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize(width: self.collectionView.frame.size.width, height: 510)
        default:
            return CGSize()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch indexPath.section {
        case 0:
            let width = collectionView.bounds.width
            let height = CGFloat(160)
            return CGSize(width: width, height: height)
        case 1:
            let width = (view.frame.width - spacing * 4) / 3
            return CGSize(width: width, height: width)
        default:
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case 0:
            return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        case 1:
            return UIEdgeInsets(top: 0, left: spacing, bottom: spacing, right: spacing)
        default:
            return UIEdgeInsets()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}

extension ProfileViewController: PostViewControllerDelegate {
    func reloadTable() {
        self.fetchUser()
    }
}


extension ProfileViewController: StretchyProtocol {
    func play(url: URL) {
        let playerItem: AVPlayerItem = AVPlayerItem(url: url)
        self.player = AVPlayer(playerItem: playerItem)
        player?.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 10), queue: DispatchQueue.main) { [weak self] time in
            guard let self = self else { return }
            let currentTime = Float(CMTimeGetSeconds(time))
            let duration = Float(CMTimeGetSeconds(playerItem.duration))
            let progress = currentTime / duration
            self.header?.progressBar.value = progress
            // Check if the song has ended
            if currentTime >= duration {
                self.header?.progressBar.value = 0.0
                self.header?.progressBar.alpha = 0.0
                self.stop()
                self.header?.playSongButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
            }
        }
        player?.play()
        self.header?.progressBar.alpha = 1.0
    }
    
    func stop() {
        self.header?.progressBar.value = 0.0
        self.player?.pause()
    }
    
    func openFileManager() {
        present(filePicker, animated: true)
    }
}


//MARK: DOCUMENTPICKER
extension ProfileViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let storageRef = Storage.storage().reference().child("songs/\(uid)/\(url.lastPathComponent)")
        waitingSpinnerEnable(activity: self.spinnerViewForPutTrack, active: true)
        titleSpinner.isHidden = false
        UIView.animate(withDuration: 1) {
            self.collectionView.alpha = 0.2
            self.collectionView.isScrollEnabled = false
        }
        storageRef.putFile(from: url, metadata: nil) { (_, error) in
            if let error {
                print("Error uploading song: \(error.localizedDescription)")
                return
            }
            print("Song uploaded successfully")
            Database.database().reference().child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["loveSong" : url.lastPathComponent]) { error, ref in
                if let error {
                    print(error)
                    return
                }
                waitingSpinnerEnable(activity: self.spinnerViewForPutTrack, active: false)
                UIView.animate(withDuration: 0.5) {
                    self.collectionView.alpha = 1.0
                    self.collectionView.isScrollEnabled = true
                }
                self.titleSpinner.isHidden = true
                self.fetchUser()
                print("succes download sound in User in Firebase Library")
            }
        }
    }
}


//MARK: SETUP NAVIGATIONBUTTON
extension ProfileViewController {
    
    func setupNavigationButton(user: User) {
        let plusButton: UIBarButtonItem = {
            let barButtonMenu = UIMenu(title: "Выберите действие", children: [
                UIAction(title: NSLocalizedString("Создать пост", comment: ""), image: UIImage(systemName: "square.and.pencil"), handler: { _ in
                    self.addPostInCollection()
                }),
                UIAction(title: NSLocalizedString("Создать историю", comment: ""), image: UIImage(systemName: "hand.tap"), handler: { _ in
                    print("Story's")
                })
            ])
            let plus = UIBarButtonItem()
            plus.image = UIImage(systemName: "plus")
            plus.tintColor = UIColor.createColor(light: .black, dark: .white)
            plus.menu = barButtonMenu
            return plus
        }()
        
        let ellipsisButtonForDeleteMusic: UIBarButtonItem = {
            let barButtonMenu = UIMenu(title: "Выберите действие", children: [
                UIAction(title: NSLocalizedString("Мой рейтинг", comment: ""), image: UIImage(named: "trophy.circle.fill@20x"), handler: { _ in
                    self.presentRating()
                }),
                UIAction(title: NSLocalizedString("Изменить аватар", comment: ""), image: UIImage(systemName: "person.fill.viewfinder"), handler: { _ in
                    self.presentImagePickerForUser()
                }),
                UIAction(title: NSLocalizedString("Изменить статус", comment: ""), image: UIImage(systemName: "heart.text.square.fill"), handler: { _ in
                    self.addStatus()
                }),
                UIAction(title: NSLocalizedString("Удалить песню", comment: ""), image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
                    self.deleteMusic()
                }),
                UIAction(title: NSLocalizedString("Выйти из аккаунта", comment: ""), image: UIImage(systemName: "hands.sparkles.fill"), attributes: .destructive, handler: { _ in
                    self.logOut()
                })
            ])
            
            let ellipsis = UIBarButtonItem()
            ellipsis.image = UIImage(systemName: "ellipsis")
            ellipsis.tintColor = UIColor.createColor(light: .black, dark: .white)
            ellipsis.menu = barButtonMenu
            return ellipsis
        }()
        
        let ellipsisButton: UIBarButtonItem = {
            let barButtonMenu = UIMenu(title: "Выберите действие", children: [
                UIAction(title: NSLocalizedString("Мой рейтинг", comment: ""), image: UIImage(named: "trophy.circle.fill@20x"), handler: { _ in
                    self.presentRating()
                }),
                UIAction(title: NSLocalizedString("Изменить аватар", comment: ""), image: UIImage(systemName: "person.fill.viewfinder"), handler: { _ in
                    self.presentImagePickerForUser()
                }),
                UIAction(title: NSLocalizedString("Изменить статус", comment: ""), image: UIImage(systemName: "heart.text.square.fill"), handler: { _ in
                    self.addStatus()
                }),
                UIAction(title: NSLocalizedString("Добавить песню", comment: ""), image: UIImage(systemName: "music.note"), handler: { _ in
                    self.openFileManager()
                }),
                UIAction(title: NSLocalizedString("Выйти из аккаунта", comment: ""), image: UIImage(systemName: "hands.sparkles.fill"), attributes: .destructive, handler: { _ in
                    self.logOut()
                })
            ])
            
            let ellipsis = UIBarButtonItem()
            ellipsis.image = UIImage(systemName: "ellipsis")
            ellipsis.tintColor = UIColor.createColor(light: .black, dark: .white)
            ellipsis.menu = barButtonMenu
            return ellipsis
        }()
        
        let messageButton = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(pushMessageController))
        messageButton.tintColor = #colorLiteral(red: 0.1758851111, green: 0.5897727013, blue: 0.9195605516, alpha: 1)
        
        let messageButtonForFriend = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(pushMessageFriendController))
        messageButtonForFriend.tintColor = #colorLiteral(red: 0.1758851111, green: 0.5897727013, blue: 0.9195605516, alpha: 1)
        
        let ratingButton = UIBarButtonItem(image: UIImage(systemName: "trophy.fill"), style: .plain, target: self, action: #selector(presentUserFriendRating))
        ratingButton.tintColor = #colorLiteral(red: 0.6754702926, green: 0.5575380325, blue: 0.4061277211, alpha: 1)
        
        if user.uid == Auth.auth().currentUser?.uid {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference().child("users").child(uid)
            ref.observeSingleEvent(of: .value, with: { snapshot in
                guard let dictionaty = snapshot.value as? [String: Any] else { return }
                if (dictionaty["loveSong"] != nil) == true {
                        self.navigationItem.rightBarButtonItems = [ellipsisButtonForDeleteMusic,plusButton]
                        self.navigationItem.leftBarButtonItems = [messageButton]
                    } else {
                        self.navigationItem.rightBarButtonItems = [ellipsisButton,plusButton]
                        self.navigationItem.leftBarButtonItems = [messageButton]
                    }
                })
        } else {
            navigationItem.rightBarButtonItems = [messageButtonForFriend,ratingButton]
        }
    }
}
