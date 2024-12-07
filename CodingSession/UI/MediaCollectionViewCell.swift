//
//  MediaCollectionViewCell.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit

class MediaCollectionViewCell: UICollectionViewCell {

    var thumbImageView: UIImageView!
    var durationLabel: UILabel!
    
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
        
        thumbImageView = UIImageView(frame: .zero)
        contentView.addSubview(thumbImageView)
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        thumbImageView.contentMode = .scaleAspectFill
        thumbImageView.clipsToBounds = true
        
        durationLabel = UILabel(frame: .zero)
        contentView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.leading.equalTo(8)
            make.bottom.equalTo(-8)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
