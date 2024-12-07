//
//  MediaPresenter.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import Photos
import UIKit

protocol MediaPresentable {
    func loadMediaAssets() -> [PHAsset]
    func getImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void)
    func getTitle(for asset: PHAsset) -> String?
}

class MediaPresenter: MediaPresentable {

    static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.unitsStyle = .positional
        return formatter
    }()

    let mediaService: MediaService
    weak var view: MediaViewController?

    init(mediaService: MediaService, view: MediaViewController) {
        self.mediaService = mediaService
        self.view = view
    }

    func loadMediaAssets() -> [PHAsset] {
        let assets = mediaService.loadMediaAssets()
        return assets
    }

    func getImage(for asset: PHAsset, completion: @escaping (UIImage?) -> Void) {
        let manager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.isSynchronous = false
        requestOptions.deliveryMode = .highQualityFormat

        let targetSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)  // Размер изображения. Вы можете установить другой размер, если нужно меньшее разрешение для превью.

        manager.requestImage(
                for: asset,
                targetSize: targetSize,
                contentMode: .aspectFill,
                options: requestOptions) { (image, _) in
                    completion(image)
        }
    }

    func getTitle(for asset: PHAsset) -> String? {
        return Self.formatter.string(from: asset.duration)
    }
}
