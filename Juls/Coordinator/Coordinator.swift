//
//  Coordinator.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

protocol FinishingCoordinator: Coordinator {
    var onFinish: (() -> Void)? { get set }
}

class BaseCoordinator {

    private(set) var childCoordinators: [Coordinator] = []
    
    func addDependency(_ coordinator: Coordinator) {
        for element in childCoordinators {
            if element === coordinator { return }
        }
        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: Coordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
            else { return }

        for (index, element) in childCoordinators.enumerated() {
            if element === coordinator {
                childCoordinators.remove(at: index)
                break
            }
        }
    }

    func removeAll() {
        childCoordinators.removeAll()
    }
}
