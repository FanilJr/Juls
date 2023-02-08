//
//  AppCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit
import Firebase

final class AppCoordinator: BaseCoordinator, Coordinator {
    private let viewControllerFactory: ViewControllersFactoryProtocol
    private let tabBarController = MainTabBarController()
    private var window: UIWindow?
    private let scene: UIWindowScene
    
    private enum Constants {
        static let newsImageName: String = "newspaper.circle"
        static let profileImageName: String = "person.circle"
        static let postFavoritesImageName: String = "heart.circle"
        static let playerImageName: String = "play.circle"
        static let searchImageName: String = "magnifyingglass.circle"
        static let ribbonImageName: String = "house.circle"
        static let settingsImageName: String = "gearshape.circle"
        static let infoImageName: String = "info.circle"
    }
    
    private enum ConstantsSelect {
        static let newsImageName: String = "newspaper.circle.fill"
        static let profileImageName: String = "person.circle.fill"
        static let postFavoritesImageName: String = "heart.circle.fill"
        static let playerImageName: String = "play.circle.fill"
        static let searchImageName: String = "magnifyingglass.circle.fill"
        static let ribbonImageName: String = "house.circle.fill"
        static let settingsImageName: String = "gearshape.circle.fill"
        static let infoImageName: String = "info.circle.fill"
    }

    init(scene: UIWindowScene, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.scene = scene
        self.viewControllerFactory = viewControllerFactory
        super.init()
    }

    func start() {
        initWindow()
        initTabBarController()
    }

    private func initWindow() {
        let window = UIWindow(windowScene: scene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func initTabBarController() {
        tabBarController.viewControllers = settingsViewControllers()
        tabBarController.selectedIndex = 3
    }
    
    private func settingsViewControllers() -> [UIViewController] {
        
        //MARK: NEWS
        let newsVc = viewControllerFactory.viewController(for: .news)
        let navNewsVC = createNavController(for: newsVc, title: String("Новости").localized, image: UIImage(systemName: Constants.newsImageName)!, selectImage: UIImage(systemName: ConstantsSelect.newsImageName)!)
        let newsCoordinator = NewsCoordinator(navigationController: navNewsVC, viewControllerFactory: viewControllerFactory)
        
        //MARK: SEARCH
        let searchVC = viewControllerFactory.viewController(for: .search)
        let navSearchVC = createNavController(for: searchVC, title: String("Поиск"), image: UIImage(systemName: Constants.searchImageName)!, selectImage: UIImage(systemName: ConstantsSelect.searchImageName) ?? UIImage())
        let searchCoordinator = SearchCoordinator(navigationController: navSearchVC, viewControllerFactory: viewControllerFactory)
        
        //MARK: HOME
        let homeVC = viewControllerFactory.viewController(for: .home)
        let navHomeVC = createNavController(for: homeVC, title: String("Лента"), image: UIImage(systemName: Constants.ribbonImageName)!, selectImage: UIImage(systemName: ConstantsSelect.ribbonImageName) ?? UIImage())
        let homeCoordinator = HomeCoordinator(navigationController: navHomeVC, viewControllerFactory: viewControllerFactory)
        
        //MARK: SETTINGS
        let infoVC = viewControllerFactory.viewController(for: .info)
        let navInfoVC = createNavController(for: infoVC, title: String("Информация"), image: UIImage(systemName: Constants.infoImageName)!, selectImage: UIImage(systemName: ConstantsSelect.infoImageName) ?? UIImage())
        let _ = InfoCoordinator(navigationController: navInfoVC, viewControllerFactory: viewControllerFactory)


        addDependency(searchCoordinator)
        addDependency(homeCoordinator)
        addDependency(newsCoordinator)
//        addDependency(infoCoordinator)

        searchCoordinator.start()
        homeCoordinator.start()
        newsCoordinator.start()
//        infoCoordinator.start()
        
        if Auth.auth().currentUser == nil {
            let loginViewModel = LoginViewModel()
            let logInVc = viewControllerFactory.viewController(for: .login(viewModel: loginViewModel))
            let navLogInVc = createNavController(
                for: logInVc,
                title: String("Авторизация").localized,
                image: UIImage(systemName: Constants.profileImageName)!, selectImage: (UIImage(systemName: ConstantsSelect.profileImageName) ?? UIImage()
            ))
            let logInCoordinator = LogInCoordinator(navigationController: navLogInVc, viewControllerFactory: viewControllerFactory)
            addDependency(logInCoordinator)
            logInCoordinator.start()
            return [navNewsVC, navSearchVC, navHomeVC, navLogInVc]
        }
        
        let profileViewModel = ProfileViewModel()
        let profileVc = viewControllerFactory.viewController(for: .profile(viewModel: profileViewModel)) as! ProfileViewController
        let navProfileInVc = createNavController(
            for: profileVc,
            title: String("Профиль").localized,
            image: UIImage(systemName: Constants.profileImageName)!, selectImage: (UIImage(systemName: ConstantsSelect.profileImageName) ?? UIImage()))
        let profileCoordinator = ProfileCoordinator(navigationController: navProfileInVc, viewControllerFactory: viewControllerFactory)
        
        addDependency(profileCoordinator)
        profileCoordinator.start()
        return [navNewsVC, navSearchVC, navHomeVC, navProfileInVc]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage, selectImage: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectImage
        navController.navigationBar.prefersLargeTitles = false
        rootViewController.navigationItem.title = title
        return navController
    }
}
