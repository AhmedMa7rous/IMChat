//
//  ChatCollectionViewDataSourceImplement.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

public extension ChatCollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatMessages.count
    }
    func collectionView(_ collectionView: UICollectionView, messagesInSection section: Int) -> [ChatMessage] {
        return chatMessages
    }
    func collectionView(_ collectionView: UICollectionView, setMessagesInSection messages: [ChatMessage]) {
        self.chatMessages.removeAll()
        self.chatMessages.append(contentsOf: messages)
    }
    
}
