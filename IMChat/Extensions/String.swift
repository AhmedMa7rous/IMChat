//
//  String.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
// MARK: - Strings
extension String {
    /// get localize string for key from localizable files
    var IMlocalized: String {
        let char = "\""
        print("\(char)\(self)\(char) = \(char) \(char);")
        guard let languageStringsFilePath = Bundle.main.path(forResource: IMChat.setting.language, ofType: "lproj") else {
            return Bundle.main.localizedString(forKey: self, value: nil, table: nil)
        }
        return Bundle(path: languageStringsFilePath)?.localizedString(forKey: self, value: nil, table: nil) ?? self
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

extension String {
    func IMlineHeight(space: CGFloat = 2) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = space // Whatever line spacing you want in points
        if IMChat.setting.language == "ar" {
            paragraphStyle.alignment = .right
        } else {
            paragraphStyle.alignment = .left
        }
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        
        // *** Set Attributed String to your label ***
        return attributedString
    }
    func IMheightWithConstrainedWidth(width: CGFloat, font: UIFont = .systemFont(ofSize: 15)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    func IMwidthWithConstrainedWidth(width: CGFloat, font: UIFont = .systemFont(ofSize: 15)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
    }
}
