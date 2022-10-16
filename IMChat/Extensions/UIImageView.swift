//
//  DownloadImage.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
extension UIImageView {
    func downloadIMChat(url: String?, andPlaceholder placeholder: UIImage? = nil) {
        self.image = placeholder
        guard var string = url else { return }
        string = IMChatsafeUrl(url: string)
        let url = URL(string: string)
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    func IMChatsafeUrl(url: String) -> String {
        let safeURL = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        return safeURL
    }
    
}
