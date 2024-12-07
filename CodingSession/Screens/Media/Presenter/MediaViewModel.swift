//
//  MediaPresenter.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import RxSwift
import Photos
import UIKit

final class MediaViewModel {

    enum State {
        case loading
        case empty
        case loaded
    }

    let state: BehaviorSubject<State>  = .init(value: .loading)
    var assetsCount: Int { assets.count }

    private let mediaService: MediaService
    private var assets: [PHAsset] = []

    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }

    func loadMediaAssets() -> Disposable {
        state.onNext(.loading)
        return mediaService.fetchMediaAssets()
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] assets in
                self?.assets = assets
                self?.state.onNext(assets.isEmpty ? .empty : .loaded)
            })
    }

    func observeImage(for indexPath: IndexPath, size: CGSize) -> Observable<UIImage?> {
        let asset = assets[indexPath.item]
        return mediaService.fetchImage(for: asset, size: size)
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.instance)
            .asObservable()
    }

    func getTitle(for indexPath: IndexPath) -> String? {
        let asset = assets[indexPath.item]
        return Self.formatter.string(from: asset.duration)
    }
}

private extension MediaViewModel {

    static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.unitsStyle = .positional
        return formatter
    }()
}
