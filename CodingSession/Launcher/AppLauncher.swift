//
//  AppLauncher.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit

final class AppLauncher {
    
    let window: UIWindow
    
    init(with bounds: CGRect) {
        window = UIWindow(frame: bounds)
    }
    
    func initFirstScreen() {
        window.rootViewController = FeatureFactory.makeMediaFeature()
    }
}
