//
//  ViewControllerFactory.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import UIKit

enum TypeOfViewController {
    case main
    case login(viewModel: LoginViewModel)
    case profile(viewModel: ProfileViewModel)
    case home
    case news
    case search
    case match
    case game
}

extension TypeOfViewController {
    func makeViewController() -> UIViewController {
        switch self {
        case .main:
            return MainTabBarController()
        case .login(let viewModel):
            return LogInViewController(viewModel: viewModel)
        case .profile(let viewModel):
            return ProfileViewController(viewModel: viewModel)
        case .home:
            return HomeViewController()
        case .news:
            return NewsListController()
        case .search:
            return SearchViewController()
        case .match:
            return MatchViewController()
        case .game:
            return GameViewController()
        }
    }
}

protocol ViewControllersFactoryProtocol {
    func viewController(for typeOfVc: TypeOfViewController) -> UIViewController
}

final class ViewControllerFactory: ViewControllersFactoryProtocol  {
    func viewController(for typeOfVc: TypeOfViewController) -> UIViewController {
        return typeOfVc.makeViewController()
    }
}
