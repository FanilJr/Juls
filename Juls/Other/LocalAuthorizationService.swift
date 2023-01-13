//
//  LocalAuthorizationService.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import Foundation
import LocalAuthentication

final class LocalAuthorizationService {
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        let reason = "Please authenticate to proceed."
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return }
        context
            .evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason,
                reply: { success, error in
                    DispatchQueue.main.async {
                        if success {
                            authorizationFinished(true)
                        } else {
                            guard let error = error else { return }
                            print(error.localizedDescription)
                            authorizationFinished(false)
                        }
                    }
                }
            )
    }
}

