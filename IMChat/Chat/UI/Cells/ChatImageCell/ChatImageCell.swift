//
//  ChatImageCell.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import UIKit

class ChatImageCell: ChatCollectionViewCell {
    @IBOutlet weak var messageImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.handleImage()
        // Initialization code
    }
    override func setup() {
        super.setup()
        setupCorners(view: messageImage)
        switch message?.kind {
            case .image(let url):
                messageImage.downloadIMChat(url: url)
            case .localImage(let image):
                messageImage.image = image
            default:
                break
        }
    }
    func handleImage() {
//        messageImage.UIViewAction { [weak self] in
//            switch self?.message?.kind {
//                case .image(let url):
//                    self?.displayImage(view: UIApplication.topViewController(), image: url)
//                case .localImage(let image):
//                    self?.displayImage(view: UIApplication.topViewController(), image: image)
//                default:
//                    break
//            }
//        }
    }
}
