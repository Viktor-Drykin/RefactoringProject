//
//  MediaViewController.swift
//  CodingSession
//
//  Created by Pavel Ilin on 01.11.2023.
//

import UIKit
import RxSwift
import SnapKit

final class MediaViewController: UIViewController {

    enum Constant {
        static let loadingMessage = "Loading..."
        static let noDataMessage = "There is nothing to show."
    }

    enum State {
        case loading
        case empty
        case loaded
    }

    var presenter: MediaPresentable?

    var state: State = .loading {
        didSet {
            collectionView.reloadData()
            switch state {
            case .loading:
                loadingLabel.text = Constant.loadingMessage
                loadingLabel.isHidden = false
            case .empty:
                loadingLabel.text = Constant.noDataMessage
                loadingLabel.isHidden = false
            case .loaded:
                loadingLabel.isHidden = true
            }
        }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: MediaCollectionViewLayout()
        )
        collectionView.backgroundColor = .gray
        return collectionView
    }()

    private lazy var loadingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        presenter?.loadMediaAssets()
    }

    private func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(loadingLabel)

        collectionView.dataSource = self
        collectionView.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.defaultReuseIdentifier)

        setupLayout()
    }

    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        loadingLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.view)
            make.centerX.equalTo(self.view)
        }
    }
}

extension MediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.defaultReuseIdentifier, for: indexPath)

        guard let cell = cell as? MediaCollectionViewCell else { return cell }

        presenter?.getImage(for: indexPath,
                            size: cell.bounds.size,
                            completion: { [weak cell] image in
            cell?.set(image: image)
        })
        cell.set(title: presenter?.getTitle(for: indexPath))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.assetsCount ?? 0
    }
}
