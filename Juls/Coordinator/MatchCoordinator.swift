//
//  MatchCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 20.03.2023.
//

import UIKit

final class MatchCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let viewController = viewControllerFactory.viewController(for: .match ) as! MatchViewController
        navigationController?.setViewControllers([viewController], animated: false)
    }
}
