//
//  ReusableView.swift
//  CodingSession
//
//  Created by Viktor Drykin on 07.12.2024.
//

import UIKit

protocol ReusableView: AnyObject {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        let nameComponents = NSStringFromClass(self).components(separatedBy: ".")
        if nameComponents.count == 1 {
            return nameComponents.first!
        } else {
            return nameComponents.last!
        }
    }
}

extension UICollectionViewCell: ReusableView { }
