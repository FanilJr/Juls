//
//  LoginViewController.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit

typealias Handler = (Result<String, Error>) -> Void

protocol LogInViewControllerDelegate: AnyObject {
    func tappedButton()
    func tappedRegister()
}
protocol LogInViewControllerCheckerDelegate: AnyObject {
    func login(inputLogin: String, inputPassword: String, completion: @escaping Handler)
    func signOut()
}

class LogInViewController: UIViewController {

    private let viewModel: LoginViewModel
    var delegate: LogInViewControllerCheckerDelegate?
    var showProfileVc: (() -> Void)?
    var showRegistrationVc: (() -> Void)?
    
    private lazy var loginView: LoginView = {
        let loginView = LoginView()
        loginView.translatesAutoresizingMaskIntoConstraints = false
        return loginView
    }()
    
    let background: UIImageView = {
        let back = UIImageView()
        back.image = UIImage(named: "back")
        back.translatesAutoresizingMaskIntoConstraints = false
        return back
    }()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupWillAppear()
    }
    
    private func setupDidLoad() {
        self.navigationController?.navigationBar.backgroundColor = .clear
        view.backgroundColor = .white
        layout()
        loginView.delegate = self
        loginView.checkerDelegate = delegate
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupWillAppear() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func layout() {
        view.addSubview(background)
        view.addSubview(loginView)
        
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: view.topAnchor),
            background.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loginView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginView.topAnchor.constraint(equalTo: view.topAnchor),
            loginView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


// MARK: - LoginViewDelegate
extension LogInViewController: LogInViewControllerDelegate {
    func tappedRegister() {
        let alertController = UIAlertController(title: "Браво 👏", message: "Вы успешно прошли регистрацию!", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.viewModel.send(.showProfileVc)
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true)
        
    }
    
    func tappedButton() {
        viewModel.send(.showProfileVc)
    }
}
