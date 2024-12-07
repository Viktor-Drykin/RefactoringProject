//
//  AppLauncher.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit

class AppLauncher {

    let window: UIWindow

    init(with bounds: CGRect) {
        window = UIWindow(frame: bounds)
    }

    func initFirstScreen() {
        window.rootViewController = ViewController()
    }

    func makeAppVisible() {
        window.makeKeyAndVisible()
    }
}
