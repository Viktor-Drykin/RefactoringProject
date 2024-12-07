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
        case noAuthorized
        case loading
        case empty
        case loaded
    }

    let state: BehaviorSubject<State>  = .init(value: .loading)
    var assetsCount: Int { assets.count }

    private let mediaService: MediaService
    private let photoAuthorisationProvider: PhotoAuthorisationProvider
    private var assets: [PHAsset] = []

    init(mediaService: MediaService, photoAuthorisationProvider: PhotoAuthorisationProvider) {
        self.photoAuthorisationProvider = photoAuthorisationProvider
        self.mediaService = mediaService
    }

    func loadMediaAssets() -> Disposable {
        photoAuthorisationProvider.checkIfAllowed()
            .do(onNext: { [weak self] isAuthorized in
                self?.state.onNext(isAuthorized ? .loading : .noAuthorized)
            })
            .filter { $0 }
            .flatMap { [weak self] state in
                guard let self else { return Observable.just([PHAsset]()) }
                return self.mediaService.fetchMediaAssets()
            }
            .do(onNext: { [weak self] assets in
                self?.assets = assets
            })
            .map { $0.isEmpty ? .empty : .loaded }
            .bind(to: state)
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
