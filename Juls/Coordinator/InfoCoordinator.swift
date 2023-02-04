//
//  InfoCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 04.02.2023.
//

import Foundation
import UIKit

final class InfoCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let viewController = viewControllerFactory.viewController(for: .info) as! InfoViewController
        navigationController?.setViewControllers([viewController], animated: false)
    }
}

