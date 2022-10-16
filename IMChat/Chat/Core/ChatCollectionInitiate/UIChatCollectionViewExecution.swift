//
//  UIChatCollectionViewExecution.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

protocol UIChatCollectionViewExecution {
    var handler: UIChatCollectionViewExecutionHandler! { get set }
    mutating func initializeChatCollectionView(collectionView: UICollectionView, dataSource: ChatCollectionViewDataSource?)
}
