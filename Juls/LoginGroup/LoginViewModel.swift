//
//  LoginViewModel.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation

final class LoginViewModel {
    var showProfileVc: (() -> Void)?
    var showRegistrationVc: (() -> Void)?

    func send(_ action: Action){
        switch action {
        case .showProfileVc:
            showProfileVc?()
        case .showRegistrationVc:
            showRegistrationVc?()
        }
    }
}

extension LoginViewModel {
    enum Action {
        case showProfileVc
        case showRegistrationVc
    }
}
