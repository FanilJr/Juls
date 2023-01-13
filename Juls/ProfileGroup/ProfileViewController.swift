//
//  ProfileViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import AVFoundation

class ProfileViewController: UIViewController {
    
    var user: User?
    var userId: String?
    var posts = [Post]()
    private let customMessagePost = CustomMessagePost()
    private let viewModel: ProfileViewModel
    private let mapView = MapView()
    private let saveView = SaveView()
    private let numbersSection = [PhotosTableViewCell(), MainTableViewCell(), PostTableViewCell()]
    private let header = ProfileHeaderView()
    private let profileImageView = ProfileImageView()
    private let infoView = InfoView()
    private let imagePicker = UIImagePickerController()
    private var currentImage: UIImageView?
    
    let systemSoundID: SystemSoundID = 1016
    let systemSoundID2: SystemSoundID = 1018
    var lastRowDisplay = 0
    private var cellIndex = 0
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
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
        back.image = UIImage(named: "sunset")
        back.clipsToBounds = true
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    /// ВАЖНО!!! задал .insetGroup, чтобы корнер радиус применился к всем ячейкам автоматически, но при этом нельзя применить конкретно к тейбл вью корнер радиус, если поставить .grouped, тогда можно для тейбл вью поставить cornerRadius и задать конкретно к ячейкам например "if indexPath.row == 0 maskedCorner" и не забыть вернуть констрейнты с отступами лево и право тейбл вью
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "MainTableViewCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosTableViewCell")
        return tableView
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
        header.user = user
        setupTableView()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.isEditing = true
        header.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        fetchUser()
//        fetchOrderedPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
        
    func setupTableView() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        [background, tableView, spinnerView].forEach({ view.addSubview($0) })
            
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leftAnchor.constraint(equalTo: view.leftAnchor),
            background.rightAnchor.constraint(equalTo: view.rightAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
            tableView.topAnchor.constraint(equalTo: background.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: background.bottomAnchor),
            
            spinnerView.topAnchor.constraint(equalTo: tableView.topAnchor,constant: 300),
            spinnerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numbersSection.count
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return posts.count
        default:
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as!
            MainTableViewCell
            cell.backgroundColor = .clear
            cell.first.text = "Имя: "
            cell.two.text = "Возраст: "
            cell.three.text = "Семейное положение: "
            cell.four.text = "Рост: "
            cell.five.text = "Привычки: "
            cell.delegate = self
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            if let uid = Auth.auth().currentUser?.uid {
                Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { snapshot in
                    
                    guard let dictionary = snapshot.value as? [String: Any] else { return }
                    
                    self.user = User(uid: uid, dictionary: dictionary)
                    
                    DispatchQueue.main.async {
                        cell.name.text = self.user?.name
                        cell.ageUser.text = self.user?.age
                        cell.statusLife.text = self.user?.lifeStatus
                        cell.heightUser.text = self.user?.height
                    }
                }) { err in
                    print("Failet to setup user", err)
                }
            }
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as! PhotosTableViewCell
            cell.tuchNew = self
            cell.backgroundColor = .clear
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            cell.backgroundColor = .clear
            cell.post = posts[indexPath.item]
            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            viewModel.send(.showPhotosVc)
        }
        if indexPath.section == 2 {
            self.cellIndex = indexPath.row
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        header.scrollViewDidScroll(scrollView: tableView)
    }
}
    
extension ProfileViewController: UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
        
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        switch section {
        case 0:
            return header
        case 1:
            return nil
        case 2:
            return nil
            
        default:
            return nil
        }
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
}
    
extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        customMessagePost.customImage.image = pickedImage
//        if currentImage?.image == customAlert.customImage.image {
//            currentImage?.image = pickedImage
            dismiss(animated: true)
            print("post в имейдж пикер")
            
//        } else {
//            currentImage?.image = pickedImage
//            waitingSpinnerEnable(true)
//            dismiss(animated: true)
//            self.saveChanges()
//            print("header в имейдж пикер релоад")
//        }
    }
}

//MARK: FETCH USER, FETCH POSTS, SAVE CHANGE
extension ProfileViewController {
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { user in
            self.user = user
            self.tableView.reloadData()
            self.fetchPostsWithUser(user: user)
            print("Перезагрузка в ProfileViewController fetchUser")
        }
    }
    
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
    
    func saveChanges() {
        let imageName = NSUUID().uuidString
        let storedImage = Storage.storage().reference().child("profile_image").child(imageName)
        
        if let uploadData = header.avatarImageView.image?.jpegData(compressionQuality: 0.3) {
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
                            NSLayoutConstraint.activate([
                                self.saveView.topAnchor.constraint(equalTo: self.tableView.topAnchor,constant: 300),
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
        self.tableView.reloadData()
    }
    
    func saveToDatabaseWithImageUrl(imageUrl: String) {
        
        print("PUSH PUSH PUSH")
        
        guard let postImage = customMessagePost.customImage.image else { return }
        guard let caption = customMessagePost.customTextfield.text else { return }
        
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
        AudioServicesPlaySystemSound(self.systemSoundID2)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.header.avatarImageView.alpha = 1
            self.customMessagePost.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.blure.alpha = 0
        })
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.customMessagePost.removeFromSuperview()
            self.blure.removeFromSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.customMessagePost.transform = CGAffineTransform(translationX: 0, y: -600)
        })
    }
}

//MARK: Редактирование информации пользователя
extension ProfileViewController: InfoDelegate {
    
    func cancelSave() {
        UIView.animate(withDuration: 0.8, animations: {
            self.header.avatarImageView.alpha = 1
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -790)
            self.blure.alpha = 0
        })
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.infoView.removeFromSuperview()
            self.blure.removeFromSuperview()
            self.tableView.reloadData()
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
            self.header.avatarImageView.alpha = 1
            self.infoView.transform = CGAffineTransform(translationX: 0, y: -790)
            self.blure.alpha = 0
        })
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.infoView.removeFromSuperview()
            self.blure.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
}

//MARK: Открытие меню редактирования
extension ProfileViewController: MainEditDelegate {
    
    func tapEditInfo() {
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
            self.header.avatarImageView.alpha = 0.0
            self.infoView.transform = CGAffineTransform(translationX: 0, y: 790)
            self.infoView.alpha = 1
            self.blure.alpha = 1
        })
        tabBarController?.tabBar.isHidden = true
    }

    func tapEditingStatusLife() {
        print("tap Status Life")
    }
    
    func tapOpenEditInfo() {
        print("Hello edit")
    }
}

//MARK: Расширение перехода к Фотоальбому
extension ProfileViewController: PhotosTableDelegate {
    
    func tuchUp() {
        print("tuch по кнопке delegate из ProfileViewController")
        viewModel.send(.showPhotosVc)
    }
}

//MARK: Расширение HEADERView
extension ProfileViewController: HeaderDelegate {
    
    func presentMenuAvatar() {
        print("tap in Avatar")
    }
    
    func addPhoto() {
        print("Photo")
    }
    
    func quitAccaunt() {
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
    
    func changeStatus() {
        let alert = UIAlertController(title: "Введите статус", message: "", preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "Ok", style: .default)  { [self] _ in
            let text = alert.textFields?.first?.text
            header.statusLabel.text = text
            AudioServicesPlaySystemSound(self.systemSoundID)
            tableView.reloadData()
             
            if let urlText = header.statusLabel.text {
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
    
    func imagePresentPicker() {
        print("Проверка presentImage")
        currentImage = header.avatarImageView
        present(imagePicker, animated: true)
    }
    
    func postCountsPresent() {
        viewModel.send(.showPhotosVc)
    }
    
    func presentSettings() {
        viewModel.send(.showImageSettingsVc)
    }
    func addPost() {
        view.addSubview(blure)
        view.addSubview(customMessagePost)
        customMessagePost.delegateAlert = self
            
        NSLayoutConstraint.activate([
            blure.topAnchor.constraint(equalTo: view.topAnchor),
            blure.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blure.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blure.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
            customMessagePost.topAnchor.constraint(equalTo: view.topAnchor,constant: -320),
            customMessagePost.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 50),
            customMessagePost.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -50),
            customMessagePost.heightAnchor.constraint(equalToConstant: 320),
        ])
        
        UIView.animate(withDuration: 0.5, animations: {
            self.header.avatarImageView.alpha = 0.0
            self.customMessagePost.transform = CGAffineTransform(translationX: 0, y: 600)
            self.customMessagePost.alpha = 1
            self.blure.alpha = 1
        })
        tabBarController?.tabBar.isHidden = true
    }
}

//MARK: Открытие, и отправка ПОСТА
extension ProfileViewController: MessagePostDelegate {
    
    func presentAlertImagePicker() {
        print("che kavo add Camera")
        self.currentImage = customMessagePost.customImage
        present(imagePicker, animated: true)

    }
    
    func closedPost() {
        UIView.animate(withDuration: 0.5, animations: {
            self.header.avatarImageView.alpha = 1
            self.customMessagePost.transform = CGAffineTransform(translationX: 0, y: 1200)
            self.blure.alpha = 0
        })
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.customMessagePost.removeFromSuperview()
            self.blure.removeFromSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
            self.customMessagePost.transform = CGAffineTransform(translationX: 0, y: -600)
            self.currentImage?.image = nil
        })
    }
    
    func pushPost() {
        guard let caption = customMessagePost.customTextfield.text, caption.count > 0 else { return }
        let imageName = NSUUID().uuidString
        let storedImage = Storage.storage().reference().child("posts").child(imageName)
        
        if let uploadData = customMessagePost.customImage.image?.jpegData(compressionQuality: 0.3) {
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
        self.tableView.reloadData()
    }
}

//MARK: Меню аватара (убрано)
extension ProfileViewController: ProfileImageViewDelegate {
    
    func openSetting() {
        viewModel.send(.showImageSettingsVc)
    }
    
    func tapClosed() {
        UIView.animate(withDuration: 0.8, animations: {
            self.header.avatarImageView.alpha = 1
            self.profileImageView.transform = CGAffineTransform(translationX: 0, y: -790)
            self.blure.alpha = 0
        })
        tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.profileImageView.removeFromSuperview()
            self.blure.removeFromSuperview()
        }
    }
}