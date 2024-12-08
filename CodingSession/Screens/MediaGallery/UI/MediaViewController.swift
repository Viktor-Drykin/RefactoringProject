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
        static let notAuthorized = "Provide an access to a photo gallery."
    }
    
    private let viewModel: MediaViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: MediaCollectionViewLayout()
        )
        return collectionView
    }()
    
    private lazy var loadingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        return label
    }()
    
    init(viewModel: MediaViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        subscribe()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
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
    
    private func subscribe() {
        viewModel.loadMediaAssets()
            .disposed(by: disposeBag)
        
        viewModel.state
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] state in
                self?.handle(state: state)
            }
            .disposed(by: disposeBag)
    }
    
    private func handle(state: MediaViewModel.State) {
        switch state {
        case .loading:
            loadingLabel.text = Constant.loadingMessage
            loadingLabel.isHidden = false
        case .empty:
            loadingLabel.text = Constant.noDataMessage
            loadingLabel.isHidden = false
        case .loaded:
            loadingLabel.isHidden = true
        case .noAuthorized:
            loadingLabel.text = Constant.notAuthorized
            loadingLabel.isHidden = false
        }
        collectionView.reloadData()
    }
}

extension MediaViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.defaultReuseIdentifier, for: indexPath)
        
        if let cell = cell as? MediaCollectionViewCell {
            let imageObservable = viewModel.observeImage(for: indexPath, size: cell.bounds.size)
            cell.bind(imageObservable: imageObservable)
            cell.set(title: viewModel.getTitle(for: indexPath))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.assetsCount
    }
}
