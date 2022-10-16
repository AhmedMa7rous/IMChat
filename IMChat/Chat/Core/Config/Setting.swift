//
//  Setting.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit


internal var IMChat = IM

public var IM: IMChatShared {
    if IMChatShared.Static.instance == nil {
        IMChatShared.Static.instance = IMChatShared()
    }
    return IMChatShared.Static.instance!
}



public class IMChatShared {
    public struct Static {
        static var instance: IMChatShared?
    }
    public class var instance: IMChatShared {
        if Static.instance == nil {
            Static.instance = IMChatShared()
        }
        return Static.instance!
    }
    
    public var setting: Setting = Setting()
}


public extension IMChatShared {
    class Setting {
        public var language: String = "en"
        public var textColor: UIColor = .black
        public var rightBackgroundColor: UIColor = .white
        public var secondColor: UIColor = .black
        public var leftBackgroundColor: UIColor = .black
        public var leftTextColor: UIColor = .black
        public var rightTextColor: UIColor = .black
        public var leftBorderColor: UIColor = .clear
        public var rightBorderColor: UIColor = .clear
        public var dateTextColor: UIColor = .black
        public var visibleDate: Bool = true
        public var visibleUserImage: Bool = true
        public var GOOGLE_API_KEY = ""
    }
    struct ChatCollectionViewConfig {
        static let imageHeight: CGFloat = 80
        static let locationHeight: CGFloat = 75
        static var cellBaseHeight: CGFloat = 50
        static let numberOfColumns = 1
        static var width: CGFloat = UIScreen.main.bounds.size.width - 40
    }

}
