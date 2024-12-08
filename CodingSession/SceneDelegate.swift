//
//  SceneDelegate.swift
//  CodingSession
//
//  Created by Pavel Ilin on 01.11.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var appLauncher: AppLauncher?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {


        guard let windowScene = (scene as? UIWindowScene) else { return }
        appLauncher = .init(with: windowScene.coordinateSpace.bounds)
        appLauncher?.window.windowScene = windowScene
        appLauncher?.initFirstScreen()
        appLauncher?.window.makeKeyAndVisible()
    }
}

