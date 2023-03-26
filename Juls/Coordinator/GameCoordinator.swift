//
//  GameCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 23.03.2023.
//

import UIKit

final class GameCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let viewController = viewControllerFactory.viewController(for: .game ) as! GameViewController
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
