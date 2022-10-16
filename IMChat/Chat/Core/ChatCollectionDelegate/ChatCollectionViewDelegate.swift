//
//  ChatCollectionViewDelegate.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

public protocol ChatCollectionViewDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    func collectionView(_ scrollView: UIScrollView, reloadTheTop decelerate: Bool)
}
