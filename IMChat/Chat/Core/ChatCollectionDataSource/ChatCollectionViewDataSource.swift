//
//  ChatCollectionViewDataSource.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

public protocol ChatCollectionViewDataSource: AnyObject {
    var chatMessages: [ChatMessage] { get set }
    func numberOfSections(in collectionView: UICollectionView) -> Int
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> ChatMessage?
    func collectionView(_ collectionView: UICollectionView, messagesInSection section: Int) -> [ChatMessage]
    func collectionView(_ collectionView: UICollectionView, setMessagesInSection messages: [ChatMessage])
}
