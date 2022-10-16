//
//  UIChatCollectionViewExecutionImplement.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//
import Foundation
import UIKit

extension UIChatCollectionViewExecution {
    mutating func initializeChatCollectionView(collectionView: UICollectionView, dataSource: ChatCollectionViewDataSource?) {
        handler = UIChatCollectionViewExecutionHandler()
        handler.dataSource = dataSource
        handler.collectionView = collectionView
        collectionView.delegate = handler
        collectionView.dataSource = handler
        collectionView.reloadData()
    }
}
