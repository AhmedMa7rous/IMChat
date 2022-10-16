//
//  UICollectionView.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
extension UICollectionView {
    public func IMscrollToBottom(animated: Bool = true) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear) {
            let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height)
            //self.setContentOffset(bottomOffset, animated: false)
            self.scrollRectToVisible(CGRect(x: 0, y: bottomOffset.y, width: self.frame.size.width, height: self.frame.size.height), animated: false)
        }
        
    }
    
    func IMreloadData(_ completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }
    
    func IMcell<T>(type: T.Type, _ indexPath: IndexPath, register: Bool = true) -> T {
        let ind = String(describing: type)
        if register {
            self.register(UINib(nibName: ind, bundle: Bundle(for: Self.self)), forCellWithReuseIdentifier: ind)
        }
        let cellProtcol = self.dequeueReusableCell(withReuseIdentifier: ind, for: indexPath) as? T
        if let cell = cellProtcol as? ChatCollectionViewCell {
            if let cell = cell as? T {
                return cell
            } else {
                return cellProtcol!
            }
        } else {
            return cellProtcol!
        }
    }
}



