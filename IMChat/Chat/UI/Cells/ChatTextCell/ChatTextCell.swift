//
//  ChatTextCell.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import UIKit

class ChatTextCell: ChatCollectionViewCell {
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setup() {
        super.setup()
        switch message?.kind {
            case .text(let text):
                textLbl.text = text
                textLbl.lineBreakMode = .byWordWrapping
                textLbl.attributedText = textLbl.text?.IMlineHeight(space: 4)
                if alignment == .right {
                    textLbl.textColor = IMChat.setting.rightTextColor
                } else {
                    textLbl.textColor = IMChat.setting.leftTextColor
                }
            default:
                break
        }
        let width = textLbl.text?.IMwidthWithConstrainedWidth(width: UIScreen.main.bounds.width, font: textLbl.font)
        if width ?? 0 < UIScreen.main.bounds.width - 150 {
            let percent = (width ?? 0) / 100
            if percent < 0.65 {
                containerWidth = containerWidth.setMultiplier(multiplier: percent)
            } else {
                containerWidth = containerWidth.setMultiplier(multiplier: 0.65)
            }
        }
    }
}
