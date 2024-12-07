//
//  MediaPresenter.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import Photos
import UIKit

protocol MediaPresentable {
    var assetsCount: Int { get }

    func loadMediaAssets()
    func getImage(for indexPath: IndexPath, size: CGSize, completion: @escaping (UIImage?) -> Void)
    func getTitle(for indexPath: IndexPath) -> String?
}

class MediaPresenter: MediaPresentable {

    static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.unitsStyle = .positional
        return formatter
    }()

    private let mediaService: MediaService
    private weak var view: MediaViewController?
    private var assets: [PHAsset] = []

    init(mediaService: MediaService, view: MediaViewController) {
        self.mediaService = mediaService
        self.view = view
    }

    var assetsCount: Int {
        assets.count
    }

    func loadMediaAssets() {
        view?.state = .loading
        mediaService.loadMediaAssets { [weak self] assets in
            self?.assets = assets
            if assets.isEmpty {
                self?.view?.state = .empty
            } else {
                self?.view?.state = .loaded
            }
        }
    }

    func getImage(for indexPath: IndexPath, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        let asset = assets[indexPath.item]
        mediaService.getImage(for: asset, size: size) { image in
            completion(image)
        }
    }

    func getTitle(for indexPath: IndexPath) -> String? {
        let asset = assets[indexPath.item]
        return Self.formatter.string(from: asset.duration)
    }
}
