//
//  MediaCollectionViewCell.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MediaCollectionViewCell: UICollectionViewCell {

    private lazy var thumbImageView: UIImageView = {
        let imageView  = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var durationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()

    private var disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        thumbImageView.image = nil
        set(title: nil)
    }

    private func setup() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(durationLabel)

        performLayout()
    }

    private func performLayout() {
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        durationLabel.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.bottom.equalTo(-8)
        }
    }

    func bind(imageObservable: Observable<UIImage?>) {
        imageObservable
            .bind(to: thumbImageView.rx.image)
            .disposed(by: disposeBag)
    }

    func set(title: String?) {
        durationLabel.text = title
    }
}
