//
//  ChatCollectionViewCellDateView.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

// MARK: - ...  UserImage View
extension ChatCollectionViewCell {
    func insertUserImageView() {
        removeUserImageView()
        if aligmentLayout.firstAttribute == .trailing {
            aligmentLayout.constant += 30
        } else {
            aligmentLayout.constant -= 30
        }
        
        userImageView = UserImageView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.clipsToBounds = true
        
        self.contentView.addSubview(userImageView)
        
        if alignment == .left {
            NSLayoutConstraint.activate([
                userImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                userImageView.widthAnchor.constraint(equalToConstant: 42),
                userImageView.heightAnchor.constraint(equalToConstant: 42), // Fixed height for nav menu
                userImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                userImageView.widthAnchor.constraint(equalToConstant: 42),
                userImageView.heightAnchor.constraint(equalToConstant: 42), // Fixed height for nav menu
                userImageView.centerYAnchor.constraint(equalTo: container.centerYAnchor)
            ])
            //userImageView.addLeadingConstraint(toView: contentView, constant: -contentView.frame.width)
        }
        
       
        var image = message as? ChatMessageImage
        if case image?.image?.isEmpty = true {
            image?.image = "https://www.pngkey.com/png/full/387-3875770_placeholder-image-no-photo-available-circle.png"
        }
        userImageView.userImage.downloadIMChat(url: image?.image)
    }
    func removeUserImageView() {
        if userImageView != nil {
            userImageView.removeConstraints(userImageView.constraints)
            userImageView.removeFromSuperview()
            
            if aligmentLayout.firstAttribute == .trailing {
                aligmentLayout.constant = 25
            } else {
                aligmentLayout.constant = -25
            }
        }
        
        
        
    }
    
}
