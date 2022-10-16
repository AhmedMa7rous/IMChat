//
//  ChatCollectionViewCell.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import UIKit

// MARK: - ...  Outlets --- Vars
class ChatCollectionViewCell: UICollectionViewCell {
    @IBOutlet var containerWidth: NSLayoutConstraint!
    @IBOutlet weak var container: UIView!

    var aligmentLayout: NSLayoutConstraint!
    var dateView: ChatDateView!
    var userImageView: UserImageView!
    private var containerAlignment: Chat.Direction = .left
    private var messageModel: ChatMessage?
    var path: Int?
}

// MARK: - ...  vars
extension ChatCollectionViewCell {
    var message: ChatMessage? {
        get {
            return messageModel
        } set {
            messageModel = newValue
            if case messageModel?.fromYou = true {
                alignment = .right
            } else {
                alignment = .left
            }
            setup()
        }
    }
    var alignment: Chat.Direction {
        get {
            return containerAlignment
        } set {
            containerAlignment = newValue
            setupAlignment()
        }
    }
}

// MARK: - ...  Functions
extension ChatCollectionViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.chatCollectionCellLayout(reloadAutoHeight: contentView)
        aligmentLayout = nil
        aligmentLayout = contentView.constraints.first(where: { $0.firstAttribute == .trailing })
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    @objc dynamic func setup() {
        setupCorners(view: container)
        setupContainer()
    }
}

// MARK: - ...  Setup Direction
extension ChatCollectionViewCell {
    func setupAlignment() {
        self.aligmentLayout.isActive = false
        if alignment == .left {
            self.aligmentLayout = NSLayoutConstraint(item: aligmentLayout.firstItem as Any,
                                                     attribute: .trailing,
                                                     relatedBy: aligmentLayout.relation,
                                                     toItem: aligmentLayout.secondItem,
                                                     attribute: .trailing, multiplier: aligmentLayout.multiplier,
                                                     constant: 0)
        } else {
            self.aligmentLayout = NSLayoutConstraint(item: aligmentLayout.firstItem as Any,
                                                     attribute: .leading,
                                                     relatedBy: aligmentLayout.relation,
                                                     toItem: aligmentLayout.secondItem,
                                                     attribute: .leading, multiplier: aligmentLayout.multiplier,
                                                     constant: -0)
        }
        self.aligmentLayout.isActive = true
    }
}

// MARK: - ...  Setup Cell UI
extension ChatCollectionViewCell {
    func setupContainer() {
        if alignment == .left {
            container.backgroundColor = IMChat.setting.leftBackgroundColor
            container.layer.borderColor = IMChat.setting.leftBorderColor.cgColor
            container.layer.borderWidth = 1
        } else {
            container.backgroundColor = IMChat.setting.rightBackgroundColor
            container.layer.borderColor = IMChat.setting.rightBorderColor.cgColor
            container.layer.borderWidth = 1
        }
    }
    func setupCorners(view: UIView?, radius: CGFloat = 10) {
        view?.layer.cornerRadius = radius
        if alignment == .left {
            view?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            view?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
}


// MARK: - ...  Functions
extension ChatCollectionViewCell: ChatCollectionCellLayoutDelegate {
    func chatCollectionCellLayout(_ delegate: ChatCollectionCellLayoutDelegate?, enableForCell cell: UICollectionViewCell?) -> Bool {
        return true
    }
}
