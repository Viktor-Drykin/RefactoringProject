//
//  ViewController.swift
//  CodingSession
//
//  Created by Pavel Ilin on 01.11.2023.
//

import UIKit
import RxSwift
import SnapKit
import Accelerate
import Photos

final class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: MediaCollectionViewLayout()
        )
        return collectionView
    }()

    var assets: [PHAsset] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.defaultReuseIdentifier)
        
        setupLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()


        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var videoAssets: [PHAsset] = []
           
        fetchResult.enumerateObjects { (asset, _, _) in
            videoAssets.append(asset)
        }
        
        assets = videoAssets
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.defaultReuseIdentifier, for: indexPath)

        if let cell = cell as? MediaCollectionViewCell {

            let asset = self.assets[indexPath.row]

            let manager = PHImageManager.default()
            let requestOptions = PHImageRequestOptions()

            requestOptions.isSynchronous = false
            requestOptions.deliveryMode = .highQualityFormat

            let targetSize = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.width / 3)  // Размер изображения. Вы можете установить другой размер, если нужно меньшее разрешение для превью.

            manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { (image, _) in
                cell.image = image
            }

            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.zeroFormattingBehavior = [.pad]
            formatter.unitsStyle = .positional

            cell.title = formatter.string(from: asset.duration)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
}
