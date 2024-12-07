//
//  MediaCollectionViewCell.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit
import SnapKit

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

    //TODO: remove this
    var image: UIImage! {
        didSet {
            thumbImageView.image = image
        }
    }
    
    var title: String! {
        didSet {
            durationLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        performLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(durationLabel)
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
}
