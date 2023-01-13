//
//  PhotosCoordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

final class PhotosViewCoordinator: Coordinator {
    private weak var navigationController: UINavigationController?
    private let viewControllerFactory: ViewControllersFactoryProtocol
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllersFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func start() {
        let photosVc = viewControllerFactory.viewController(for: .photosView) as! PhotosViewController
        navigationController?.pushViewController(photosVc, animated: true)
    }
}
