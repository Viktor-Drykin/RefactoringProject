//
//  MediaService.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import Photos

protocol MediaService {
    func loadMediaAssets() -> [PHAsset]
}


class MediaServiceImpl: MediaService {

    enum Constant {
        // TODO: replace to a video type
        static let mediaType = PHAssetMediaType.image
    }

    //TODO: move from Main Thread
    func loadMediaAssets() -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", Constant.mediaType.rawValue)
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var assets: [PHAsset] = []

        fetchResult.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        return assets
    }

}

