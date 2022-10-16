//
//  ChatLayout.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

protocol ChatCollectionCellLayoutDelegate: AnyObject {
    var chatCollectionCellLayout: Bool { get }
    func chatCollectionCellLayout(_ delegate: ChatCollectionCellLayoutDelegate?, enableForCell cell: UICollectionViewCell?) -> Bool
    func chatCollectionCellLayout(_ delegate: ChatCollectionCellLayoutDelegate?, setAutoHeight view: UIView?)
    func chatCollectionCellLayout(reloadAutoHeight view: UIView?)
}
