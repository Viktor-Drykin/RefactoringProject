//
//  MediaViewController.swift
//  CodingSession
//
//  Created by Pavel Ilin on 01.11.2023.
//

import UIKit
import RxSwift
import SnapKit
import Accelerate
import Photos

final class MediaViewController: UIViewController {

    var presenter: MediaPresentable?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        //TODO: rewrite it
        assets = presenter?.loadMediaAssets() ?? []
    }

    private func setupViews() {
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.defaultReuseIdentifier)

        setupLayout()
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.defaultReuseIdentifier, for: indexPath)

        if let cell = cell as? MediaCollectionViewCell {

            let asset = self.assets[indexPath.row]

            presenter?.getImage(for: asset, completion: { image in
                cell.image = image
            })

            cell.title = presenter?.getTitle(for: asset)
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets.count
    }
}
