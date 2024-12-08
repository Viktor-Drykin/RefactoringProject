//
//  MediaCollectionViewLayout.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//
import UIKit

final class MediaCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        guard let collectionView else { return }
        let size = collectionView.bounds.width / 3
        itemSize = CGSize(width: size, height: size)
        sectionInset = .zero
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }
}

