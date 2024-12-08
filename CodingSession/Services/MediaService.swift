//
//  MediaService.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import Photos
import UIKit
import RxSwift

protocol MediaService {
    func fetchMediaAssets() -> Observable<[PHAsset]>
    func fetchImage(for asset: PHAsset, size: CGSize) -> Single<UIImage?>
}

final class MediaServiceImpl: MediaService {

    enum Constant {
        static let mediaType = PHAssetMediaType.video
    }

    func fetchMediaAssets() -> Observable<[PHAsset]> {
        Single<[PHAsset]>.create { single in
            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSPredicate(format: "mediaType == %d", Constant.mediaType.rawValue)

            var assets: [PHAsset] = []
            PHAsset
                .fetchAssets(with: fetchOptions)
                .enumerateObjects { (asset, _, _) in
                    assets.append(asset)
                }
            single(.success(assets))
            return Disposables.create()
        }
        .asObservable()
    }

    func fetchImage(for asset: PHAsset, size: CGSize) -> Single<UIImage?> {
        Single<UIImage?>.create { single in
            let requestOptions = {
                let requestOptions = PHImageRequestOptions()
                requestOptions.isSynchronous = false
                requestOptions.deliveryMode = .highQualityFormat
                return requestOptions
            }()
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFill,
                options: requestOptions) { (image, _) in
                    single(.success(image))
                }
            return Disposables.create()
        }
    }
}
