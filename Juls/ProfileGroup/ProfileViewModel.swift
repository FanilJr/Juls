//
//  ProfileViewModel.swift
//  Juls
//
//  Created by Fanil_Jr on 15.02.2023.
//

import Foundation
import UIKit
import Firebase

final class ProfileViewModel {
    
    var showLoginVc: (() -> Void)?
    
    enum Action {
        case showLoginVc
    }
    
    func send(_ action: Action) {
        switch action {
        case .showLoginVc:
            showLoginVc?()
        }
    }
}
