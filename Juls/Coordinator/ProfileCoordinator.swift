//
//  ProfileCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

protocol ProfileCoordinatorFlowProtocol {
    var navigationController: UINavigationController { get }
    var viewControllerFactory: ViewControllersFactoryProtocol { get }
    
    func showPhotosVc()
    func showLoginVc()
//    func showImageSettings()
}

class ProfileCoordinatorFlow: ProfileCoordinatorFlowProtocol {
   
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(
        navigationController: UINavigationController,
        viewControllerFactory: ViewControllersFactoryProtocol
    ) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func showPhotosVc() {
        let photosViewCoordinator = PhotosViewCoordinator(
            navigationController: navigationController,
            viewControllerFactory: viewControllerFactory
        )
        photosViewCoordinator.start()
    }
    
    func showLoginVc() {
        let logInCoordinator = LogInCoordinator(navigationController: navigationController,viewControllerFactory: viewControllerFactory)
        logInCoordinator.start()
    }
    
//    func showImageSettings() {
//        let settingsViewCoordinator = SettingsCoordinator(navigationController: navigationController, viewControllerFactory: viewControllerFactory)
//        settingsViewCoordinator.start()
//    }
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
        viewModel.showPhotosVc = profileCoordinatorFlow.showPhotosVc
        viewModel.showLoginVc = profileCoordinatorFlow.showLoginVc
//        viewModel.showImageSettingsVc = profileCoordinatorFlow.showImageSettings
        navigationController?.setViewControllers([profileVc], animated: false)
    }
}
