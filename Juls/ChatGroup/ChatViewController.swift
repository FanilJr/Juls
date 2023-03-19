//
//  ChatViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 09.03.2023.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    var userFriend: User? {
        didSet {
            guard let username = userFriend?.username else { return }
            title = "Чат с \(username)"
            guard let imageBack = userFriend?.picture else { return }
            self.imageBack.loadImage(urlString: imageBack)
        }
    }
    
    var user: User? {
        didSet {
            guard let image = user?.picture else { return }
            self.authorComment.loadImage(urlString: image)
        }
    }
    
    var isRead = Bool()
    var lastMessage = String()
    var timer: Timer?
    var messages = [Message]()
    private let nc = NotificationCenter.default
    let imagePicker = UIImagePickerController()
    
    private let spinnerView: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = UIColor.createColor(light: .black, dark: .white)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    lazy var read: UILabel = {
        let read = UILabel()
        read.translatesAutoresizingMaskIntoConstraints = false
        read.text = "Прочитано"
        return read
    }()
    
    lazy var containerViewForImage: UIView = {
        let containterView = UIView()
        containterView.backgroundColor = .systemGray6
        containterView.translatesAutoresizingMaskIntoConstraints = false
        return containterView
    }()
    
    private let imageChat: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 14
        return image
    }()

    lazy var containerView: UIView = {
        let containterView = UIView()
        containterView.backgroundColor = .systemGray6
        containterView.translatesAutoresizingMaskIntoConstraints = false
        return containterView
    }()
    
    private let spinnerViewForChat: UIActivityIndicatorView = {
        let activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityView.color = UIColor.createColor(light: .black, dark: .white)
        activityView.hidesWhenStopped = true
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
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
            
    lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.delegate = self
        textfield.placeholder = "Enter comment"
        textfield.layer.cornerRadius = 16
        textfield.clipsToBounds = true
        textfield.textColor = UIColor.createColor(light: .black, dark: .white)
        textfield.backgroundColor = .systemBackground
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 0.5
        textfield.setLeftPaddingPoints(12)
        textfield.setRightPaddingPoints(40)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var authorComment: CustomImageView = {
        let image = CustomImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30/2
        image.clipsToBounds = true
        return image
    }()
    
    lazy var sendCommentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = #colorLiteral(red: 0.1758851111, green: 0.5897727013, blue: 0.9195605516, alpha: 1)
        button.setTitleColor(.createColor(light: .black, dark: .white), for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pushMessage), for: .touchUpInside)
        return button
    }()
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.menu = addMenu()
        button.showsMenuAsPrimaryAction = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor.createColor(light: .black, dark: .white)
        button.setTitleColor(.createColor(light: .black, dark: .white), for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(recognizer)
        tableView.register(LocalChatTableViewCell.self, forCellReuseIdentifier: "LocalChatTableViewCell")
        tableView.register(LocalChatWithUserTableViewCell.self, forCellReuseIdentifier: "LocalChatWithUserTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        view.endEditing(true)
    }
    
    private func setupDidLoad() {
        view.backgroundColor = .systemBackground
        waitingSpinnerForChatEnable(true)
        setupLayout()
        imagePicker.delegate = self
        guard let username = user?.username else { return }
        guard let friendsUsername = userFriend?.username else { return }
        print("open Chat", username, "with", friendsUsername, "            ~~~~~JULS~~~~~")
        fetchChat()
        timerSetup()
    }
    
    private func setupWillAppear() {
        addObserver()
        tabBarController?.tabBar.isHidden = true
    }
    
    private func addMenu() -> UIMenu {
        let addPhoto = UIAction(title: "Отправить фото",image: UIImage(systemName: "photo")) { _ in
            self.present(self.imagePicker, animated: true)
        }
        let addVideo = UIAction(title: "Отправить видео",image: UIImage(systemName: "video.badge.plus")) { _ in
            print("video")
        }
        let addGif = UIAction(title: "Отправить GIF",image: UIImage(systemName: "livephoto.play")) { _ in
            print("gif")
        }
        let menu = UIMenu(title: "Выберите действие", children: [addGif,addVideo,addPhoto])
        return menu
    }
    
    func waitingSpinnerEnable(_ active: Bool) {
        if active {
            spinnerView.startAnimating()
        } else {
            spinnerView.stopAnimating()
        }
    }
    
    func waitingSpinnerForChatEnable(_ active: Bool) {
        if active {
            spinnerViewForChat.startAnimating()
        } else {
            spinnerViewForChat.stopAnimating()
        }
    }
    
    @objc func addAction() {
        
    }
    
    func timerSetup() {
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateMessagesForTimer), userInfo: nil, repeats: true)
    }
    
    func checkFriendRead() {
        guard let friendId = userFriend?.uid else { return }
        Database.database().checkIsRead(friendUserId: friendId) { read in
            DispatchQueue.main.async {
                self.isRead = read
                if read {
                    print("Сообщение пользователем прочитано")
                } else {
                    print("Сообщение пользователем непрочитано")
                }
            }
        }
        Database.database().getLastMessage(friendUserId: friendId) { slovo in
            DispatchQueue.main.async {
                self.lastMessage = slovo
                print("Последнее сообщение", slovo)
            }
        }
    }
    
    @objc func updateMessagesForTimer() {
        fetchChat()
    }
    
    @objc func pushMessage() {
        guard let textMessage = textfield.text else { return }
        guard let userId = user?.uid else { return }
        guard let friendId = userFriend?.uid else { return }
        self.sendCommentButton.isEnabled = false
        self.sendCommentButton.alpha = 0
        self.waitingSpinnerEnable(true)
        
        Database.database().pushMessageWithChatId(userUID: userId, userFriendUID: friendId, textMessage: textMessage) { error in
            DispatchQueue.main.async {
                if let error {
                    print(error)
                }
                self.fetchChat()
                self.sendCommentButton.isEnabled = true
                self.sendCommentButton.alpha = 1
                self.waitingSpinnerEnable(false)
            }
        }
        self.textfield.text = ""
    }
    
    func fetchChat() {
        guard let userId = user?.uid else { return }
        guard let friendId = userFriend?.uid else { return }
        self.changeIsRead(read: true)
        self.checkFriendRead()
        Database.database().fetchMessageWithChatId(userUID: userId, userFriendUID: friendId) { messages in
            DispatchQueue.main.async {
                self.messages = messages
                self.tableView.setContentOffset(CGPointMake(0, self.containerView.center.y-60), animated: true)
                self.waitingSpinnerForChatEnable(false)
                self.tableView.reloadData()
            }
        }
    }
    
    func changeIsRead(read: Bool) {
        if read {
            guard let friendUID = userFriend?.uid else { return }
            Database.database().changeIsRead(friendUserId: friendUID, friendRead: read)
        }
    }
    
    func addObserver() {
        nc.addObserver(self, selector: #selector(kdbShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kdbHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeObserver() {
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func kdbShow(notification: NSNotification) {
        
        if let kdbSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset.bottom = kdbSize.height
            tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kdbSize.height, right: 0)
            
            self.containerView.transform = CGAffineTransform(translationX: 0, y: -kdbSize.height)
            tableView.setContentOffset(CGPointMake(0, containerView.center.y-60), animated: true)
        }
    }

    @objc func kdbHide() {
        tableView.contentInset.bottom = .zero
        tableView.verticalScrollIndicatorInsets = .zero
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
    
    func addImage() {
        [containerViewForImage,imageChat].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            containerViewForImage.bottomAnchor.constraint(equalTo: containerView.topAnchor),
            containerViewForImage.heightAnchor.constraint(equalTo: imageChat.heightAnchor),
            containerViewForImage.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            imageChat.topAnchor.constraint(equalTo: containerViewForImage.topAnchor,constant: 5),
            imageChat.leadingAnchor.constraint(equalTo: containerViewForImage.leadingAnchor,constant: 12),
            imageChat.heightAnchor.constraint(lessThanOrEqualToConstant: 100),
            imageChat.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func setupLayout() {
        [tableView,spinnerViewForChat,containerView].forEach { view.addSubview($0) }
        [plusButton, authorComment, textfield, sendCommentButton,spinnerView].forEach { containerView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinnerViewForChat.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinnerViewForChat.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 70),
            
            plusButton.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 12),
            plusButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 12),
            plusButton.heightAnchor.constraint(equalToConstant: 30),
            plusButton.widthAnchor.constraint(equalToConstant: 30),
            
            authorComment.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 12),
            authorComment.leadingAnchor.constraint(equalTo: plusButton.trailingAnchor,constant: 12),
            authorComment.widthAnchor.constraint(equalToConstant: 30),
            authorComment.heightAnchor.constraint(equalToConstant: 30),
            
            textfield.centerYAnchor.constraint(equalTo: authorComment.centerYAnchor),
            textfield.leadingAnchor.constraint(equalTo: authorComment.trailingAnchor,constant: 10),
            textfield.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -12),
            textfield.heightAnchor.constraint(equalToConstant: 35),
            
            sendCommentButton.centerYAnchor.constraint(equalTo: authorComment.centerYAnchor),
            sendCommentButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -20),
            sendCommentButton.heightAnchor.constraint(equalToConstant: 50),
            
            spinnerView.centerXAnchor.constraint(equalTo: sendCommentButton.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: sendCommentButton.centerYAnchor)
        ])
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let isComing = user?.uid == messages[indexPath.row].uid
        if isComing {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalChatTableViewCell", for: indexPath) as! LocalChatTableViewCell
            cell.messages = messages[indexPath.row]
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if indexPath.row == messages.count - 1 {
                if isRead {
                    cell.readLabel.text = "Прочитано"
                } else {
                    cell.readLabel.text = ""
                }
            } else {
                cell.readLabel.text = ""
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LocalChatWithUserTableViewCell", for: indexPath) as! LocalChatWithUserTableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.messages = messages[indexPath.row]
            return cell
        }
    }
}

extension ChatViewController: UITableViewDelegate {
    
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
        return true
    }
}

extension ChatViewController {
    func tapScreen() {
        let recognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        recognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(recognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
}

extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        imageChat.image = pickedImage
        dismiss(animated: true)
        self.addImage()
    }
}
