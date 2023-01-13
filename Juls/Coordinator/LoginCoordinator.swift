//
//  LoginCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

protocol LogInCoordinatorFlowProtocol {
    var navigationController: UINavigationController { get }
    var viewControllerFactory: ViewControllersFactoryProtocol { get }
    
    func showProfileVc()
}

class LogInCoordinatorFlow: LogInCoordinatorFlowProtocol {
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(
        navigationController: UINavigationController,
        viewControllerFactory: ViewControllersFactoryProtocol
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func showProfileVc() {
        let profileCoordinator = ProfileCoordinator(
            navigationController: navigationController,
            viewControllerFactory: viewControllerFactory
        )
        profileCoordinator.start()
    }
}

class LogInCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    private let logInCoordinatorFlow: LogInCoordinatorFlow
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
        self.logInCoordinatorFlow = LogInCoordinatorFlow(
            navigationController: navigationController,
            viewControllerFactory: viewControllerFactory
        )
    }
    
    func start() {
        let viewModel = LoginViewModel()
        let viewController = viewControllerFactory.viewController(for: .login(viewModel: viewModel)) as! LogInViewController
        viewModel.showProfileVc = logInCoordinatorFlow.showProfileVc
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
