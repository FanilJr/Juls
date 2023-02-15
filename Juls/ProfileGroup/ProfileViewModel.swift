//
//  ProfileViewModel.swift
//  Juls
//
//  Created by Fanil_Jr on 15.02.2023.
//

import Foundation
import UIKit

final class ProfileViewModel {
    
    var showPhotosVc: (() -> Void)?
    var showLoginVc: (() -> Void)?
    var showImageSettingsVc: (() -> Void)?
    
    
    func send(_ action: Action) {
        switch action {
        case .showPhotosVc:
            showPhotosVc?()
        case .showLoginVc:
            showLoginVc?()
        case .showImageSettingsVc:
            showImageSettingsVc?()
        }
    }
}

extension ProfileViewModel {
    
    enum Action {
        case showPhotosVc
        case showLoginVc
        case showImageSettingsVc
    }
    
    enum State {
        case initial
        case loaded
    }
}
