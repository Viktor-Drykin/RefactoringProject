//
//  ScreenFactory.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit

enum FeatureFactory {

    static func makeMediaFeature() -> UIViewController {
        let mediaService = MediaServiceImpl()
        let viewModel = MediaViewModel(mediaService: mediaService)
        let view = MediaViewController(viewModel: viewModel)
        return view
    }
}

