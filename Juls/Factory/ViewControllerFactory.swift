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
    case photosView
    case home
    case news
    case settings
    case search
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
        case .photosView:
            return PhotosViewController()
        case .home:
            return HomeViewController()
        case .news:
            return NewsListController()
        case .settings:
            return SettingsViewController()
        case .search:
            return SearchViewController()
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
