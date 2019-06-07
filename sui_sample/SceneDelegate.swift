//
//  SceneDelegate.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let theme = ColorTheme()
        let window = UIWindow(frame: UIScreen.main.bounds)
        let root = TraitObservingViewController(rootView: RootView().environmentObject(theme))
        root.theme = theme
        window.rootViewController = root
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    func sceneWillResignActive(_ scene: UIScene) {
    }
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

