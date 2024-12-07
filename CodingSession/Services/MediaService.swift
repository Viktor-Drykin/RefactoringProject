//
//  MediaService.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import Photos
import UIKit

protocol MediaService {
    func loadMediaAssets(completion: @escaping ([PHAsset]) -> Void)
    func getImage(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void)
}

class MediaServiceImpl: MediaService {

    enum Constant {
        static let mediaType = PHAssetMediaType.video
    }

    func loadMediaAssets(completion: @escaping ([PHAsset]) -> Void) {
        DispatchQueue.global().async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", Constant.mediaType.rawValue)
            let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
            var assets: [PHAsset] = []

            fetchResult.enumerateObjects { (asset, _, _) in
                assets.append(asset)
            }
            DispatchQueue.main.async {
                completion(assets)
            }
        }
    }

    func getImage(for asset: PHAsset, size: CGSize, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let manager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            requestOptions.deliveryMode = .highQualityFormat

            manager.requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFill,
                options: requestOptions) { (image, _) in
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
        }
    }

}

