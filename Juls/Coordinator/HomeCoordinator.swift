//
//  PostCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 07.01.2023.
//

import Foundation
import UIKit

final class HomeCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let viewController = viewControllerFactory.viewController(for: .home) as! HomeViewController
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
