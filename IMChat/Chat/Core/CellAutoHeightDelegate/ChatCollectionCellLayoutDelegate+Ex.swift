//
//  ChatLayoutImplement.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

extension ChatCollectionCellLayoutDelegate {
    var chatCollectionCellLayout: Bool {
        self.chatCollectionCellLayout(self, enableForCell: nil)
    }
    func chatCollectionCellLayout(_ delegate: ChatCollectionCellLayoutDelegate?, setAutoHeight view: UIView?) {
        if chatCollectionCellLayout {
            var constraints = view?.constraints ?? []
            constraints.forEach { (item) in
                if item.firstAttribute == .bottom {
                    item.priority = UILayoutPriority(rawValue: 999)
                }
            }
            view?.removeConstraints(view?.constraints ?? [])
            view?.translatesAutoresizingMaskIntoConstraints = false
            constraints.append(view!.widthAnchor.constraint(equalToConstant: IMChatShared.ChatCollectionViewConfig.width))
            view?.addConstraints(constraints)
            view?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func chatCollectionCellLayout(reloadAutoHeight view: UIView?) {
        self.chatCollectionCellLayout(self, setAutoHeight: view)
    }
}
