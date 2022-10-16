//
//  UIChatCollectionView.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

@IBDesignable
public class UIChatCollectionView: UICollectionView, UIChatCollectionViewExecution {
    var handler: UIChatCollectionViewExecutionHandler!
    var refrence: UIChatCollectionView?
    public weak var chatDataSource: ChatCollectionViewDataSource? {
        didSet {
            if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
                IMChatShared.ChatCollectionViewConfig.width = self.frame.size.width - 50
            }
            refrence = self
            refrence?.initializeChatCollectionView(collectionView: self, dataSource: chatDataSource)
        }
    }
    public weak var chatDelegate: ChatCollectionViewDelegate? {
        didSet {
            refrence?.handler.delegate = chatDelegate
        }
    }
}


public extension UIChatCollectionView {
    override var intrinsicContentSize: CGSize {
        return self.collectionViewLayout.collectionViewContentSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func reloadData() {
        super.reloadData()
    }
}
public extension UIChatCollectionView {
    func reloadData(withNewMessages messages: [ChatMessage]) {
        self.handler.setupMessages(respond: messages)
        self.handler.reload()
    }
    func reloadData(withNewMessage message: ChatMessage) {
        self.handler.up = false
        self.handler.setupMessages(respond: [message])
        self.handler.reloadItem()
    }
    func reload() {
        self.handler.up = false
        self.handler.reload()
    }
}
