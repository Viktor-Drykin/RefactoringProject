//
//  ScreenFactory.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit

enum ScreenFactory {

    static func makeMediaScreen() -> UIViewController {
        let mediaService = MediaServiceImpl()
        let view = MediaViewController()
        let presenter = MediaPresenter(mediaService: mediaService, view: view)
        view.presenter = presenter
        return view
    }
}

