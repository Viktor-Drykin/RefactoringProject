//
//  PhotoAuthorisationProvider.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import Photos
import RxSwift

protocol PhotoAuthorisationProvider {
    func checkIfAllowed() -> Observable<Bool>
}

class PhotoAuthorisationProviderImpl: PhotoAuthorisationProvider {
    func checkIfAllowed() -> Observable<Bool> {
        Observable.create { observable in
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .restricted, .denied:
                    observable.onNext(false)
                case .authorized, .limited, .notDetermined:
                    observable.onNext(true)
                @unknown default:
                    observable.onNext(false)
                }
            }
            
            return Disposables.create()
        }
    }
}
