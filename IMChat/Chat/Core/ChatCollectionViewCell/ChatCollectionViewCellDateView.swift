//
//  ChatCollectionViewCellDateView.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

// MARK: - ...  Date View
extension ChatCollectionViewCell {
    func insertDateView() {
        removeDateView()
        if let bottomConstraint = contentView.constraints.first(where: { $0.firstAttribute == .bottom }) {
            print(bottomConstraint.constant)
            bottomConstraint.constant = 38
        }

        dateView = ChatDateView(frame: CGRect(x: 0, y: 0, width: 120, height: 30))
        dateView.translatesAutoresizingMaskIntoConstraints = false
        dateView.clipsToBounds = true

        self.contentView.addSubview(dateView)
        
        NSLayoutConstraint.activate([
            dateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            dateView.heightAnchor.constraint(equalToConstant: 30), // Fixed height for nav menu
            dateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        dateView.alignment = alignment
        dateView.dateLbl.text = message?.date
        dateView.dateLbl.textColor = IMChat.setting.dateTextColor
        if case message?.fromYou = true {
            //dateView.userView.isHidden = true
            //dateView.otherView.isHidden = false
        } else {
            //dateView.userImage.setImage(url: User.getUser()?.profileImage)
            //dateView.userView.isHidden = false
            //dateView.otherView.isHidden = true
        }
    }
    func removeDateView() {
        if let bottomConstraint = contentView.constraints.first(where: { $0.firstAttribute == .bottom }) {
            if dateView != nil {
                bottomConstraint.constant = 8
                dateView.removeFromSuperview()
            }
        }

    }
    
    
}
