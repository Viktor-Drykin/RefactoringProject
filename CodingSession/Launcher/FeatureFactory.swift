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
        let photoProvider = PhotoAuthorisationProviderImpl()
        let viewModel = MediaViewModel(mediaService: mediaService, photoAuthorisationProvider: photoProvider)
        let view = MediaViewController(viewModel: viewModel)
        return view
    }
}

