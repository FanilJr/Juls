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
        static let searchImageName: String = "magnifyingglass.circle"
        static let ribbonImageName: String = "house.circle"
        static let matchImageName: String = "heart.circle"
        static let gameImageName: String = "trophy.circle"
    }
    
    private enum ConstantsSelect {
        static let newsImageName: String = "newspaper.circle.fill"
        static let profileImageName: String = "person.circle.fill"
        static let searchImageName: String = "magnifyingglass.circle.fill"
        static let ribbonImageName: String = "house.circle.fill"
        static let matchImageName: String = "heart.circle.fill"
        static let gameImageName: String = "trophy.circle.fill"
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
        tabBarController.selectedIndex = 4
    }
    
    private func settingsViewControllers() -> [UIViewController] {
        
        //MARK: NEWS
//        let newsVc = viewControllerFactory.viewController(for: .news)
//        let navNewsVC = createNavController(for: newsVc, title: String("Новости"), image: UIImage(systemName: Constants.newsImageName)!, selectImage: UIImage(systemName: ConstantsSelect.newsImageName)!)
//        let newsCoordinator = NewsCoordinator(navigationController: navNewsVC, viewControllerFactory: viewControllerFactory)
        
        //MARK: MATCH
        let matchVc = viewControllerFactory.viewController(for: .match)
        let navMatchVC = createNavController(for: matchVc, title: String("Match"), image: UIImage(systemName: Constants.matchImageName)!, selectImage: UIImage(systemName: ConstantsSelect.matchImageName)!)
        let matchCoordinator = MatchCoordinator(navigationController: navMatchVC, viewControllerFactory: viewControllerFactory)
        
        //MARK: GAME
        let gameVc = viewControllerFactory.viewController(for: .game)
        let navGameVC = createNavController(for: gameVc, title: "Game", image: UIImage(systemName: Constants.gameImageName) ?? UIImage(), selectImage: UIImage(systemName: ConstantsSelect.gameImageName) ?? UIImage())
        let gameCoordinator = GameCoordinator(navigationController: navGameVC, viewControllerFactory: viewControllerFactory)
        
        //MARK: SEARCH
        let searchVC = viewControllerFactory.viewController(for: .search)
        let navSearchVC = createNavController(for: searchVC, title: String("Поиск"), image: UIImage(systemName: Constants.searchImageName)!, selectImage: UIImage(systemName: ConstantsSelect.searchImageName) ?? UIImage())
        let searchCoordinator = SearchCoordinator(navigationController: navSearchVC, viewControllerFactory: viewControllerFactory)
        
        //MARK: HOME
        let homeVC = viewControllerFactory.viewController(for: .home)
        let navHomeVC = createNavController(for: homeVC, title: String("Лента"), image: UIImage(systemName: Constants.ribbonImageName)!, selectImage: UIImage(systemName: ConstantsSelect.ribbonImageName) ?? UIImage())
        let homeCoordinator = HomeCoordinator(navigationController: navHomeVC, viewControllerFactory: viewControllerFactory)

        addDependency(searchCoordinator)
        addDependency(homeCoordinator)
//        addDependency(newsCoordinator)
        addDependency(matchCoordinator)
        addDependency(gameCoordinator)

        searchCoordinator.start()
        homeCoordinator.start()
//        newsCoordinator.start()
        matchCoordinator.start()
        gameCoordinator.start()
        
        if Auth.auth().currentUser == nil {
            let loginViewModel = LoginViewModel()
            let logInVc = viewControllerFactory.viewController(for: .login(viewModel: loginViewModel))
            let navLogInVc = createNavController(
                for: logInVc,
                title: String("Авторизация"),
                image: UIImage(systemName: Constants.profileImageName)!, selectImage: (UIImage(systemName: ConstantsSelect.profileImageName) ?? UIImage()
            ))
            let logInCoordinator = LogInCoordinator(navigationController: navLogInVc, viewControllerFactory: viewControllerFactory)
            addDependency(logInCoordinator)
            logInCoordinator.start()
            return [navMatchVC,navGameVC, navHomeVC, navSearchVC, navLogInVc]
        }
        
        let profileViewModel = ProfileViewModel()
        let profileVc = viewControllerFactory.viewController(for: .profile(viewModel: profileViewModel)) as! ProfileViewController
        let navProfileInVc = createNavController(
            for: profileVc,
            title: String("Профиль"),
            image: UIImage(systemName: Constants.profileImageName)!, selectImage: (UIImage(systemName: ConstantsSelect.profileImageName) ?? UIImage()))
        let profileCoordinator = ProfileCoordinator(navigationController: navProfileInVc, viewControllerFactory: viewControllerFactory)
        
        addDependency(profileCoordinator)
        profileCoordinator.start()
        return [navMatchVC,navGameVC, navHomeVC,navSearchVC, navProfileInVc]
    }
    
    private func createNavController(for rootViewController: UIViewController, title: String, image: UIImage, selectImage: UIImage) -> UINavigationController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectImage
        rootViewController.navigationItem.title = title
        return navController
    }
}
