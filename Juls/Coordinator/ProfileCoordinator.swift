//
//  ProfileCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit
import Firebase

protocol ProfileCoordinatorFlowProtocol {
    var navigationController: UINavigationController { get }
    var viewControllerFactory: ViewControllersFactoryProtocol { get }
    
    func showLoginVc()
}

class ProfileCoordinatorFlow: ProfileCoordinatorFlowProtocol {
   
    var post: Post?
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(
        navigationController: UINavigationController,
        viewControllerFactory: ViewControllersFactoryProtocol
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func showLoginVc() {
        let logInCoordinator = LogInCoordinator(navigationController: navigationController,viewControllerFactory: viewControllerFactory)
        logInCoordinator.start()
    }
}

class ProfileCoordinator: Coordinator {

    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    private let profileCoordinatorFlow: ProfileCoordinatorFlow
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.profileCoordinatorFlow = ProfileCoordinatorFlow(navigationController: navigationController, viewControllerFactory: viewControllerFactory)
    }
    
    func start() {
        let viewModel = ProfileViewModel()
        let profileVc = viewControllerFactory.viewController(
            for: .profile(
                viewModel: viewModel
            )
        ) as! ProfileViewController
        
//        let userId: String?
//        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
//        Database.database().fetchUser(withUID: uid) { user in
//            profileVc.user = user
//        }
        viewModel.showLoginVc = profileCoordinatorFlow.showLoginVc
        navigationController?.setViewControllers([profileVc], animated: false)
    }
}
