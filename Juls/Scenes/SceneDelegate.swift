//
//  SceneDelegate.swift
//  Juls
//
//  Created by Fanil_Jr on 04.01.2023.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private var viewControllerFactory: ViewControllersFactoryProtocol!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        FirebaseApp.configure()
            
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGray6
            appearance.backgroundEffect = nil
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            if let titleFont = UIFont(name: "Futura-Bold", size: 15) {
            appearance.titleTextAttributes = [NSAttributedString.Key.font: titleFont]
            }
            if let titleFont = UIFont(name: "Futura-Bold", size: 31) {
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.font: titleFont]
            }

            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().tintColor = UIColor.createColor(light: .black, dark: .white)
            
            UITabBar.appearance().backgroundColor = .systemGray6
            UITabBar.appearance().tintColor = #colorLiteral(red: 0.9294139743, green: 0.2863991261, blue: 0.3659052849, alpha: 1)
            UITabBar.appearance().unselectedItemTintColor = UIColor.createColor(light: .black, dark: .systemGray)
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        viewControllerFactory = ViewControllerFactory()
        
        appCoordinator = AppCoordinator(scene: windowScene, viewControllerFactory: viewControllerFactory)
        appCoordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
//        self.saveContext()
//        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
