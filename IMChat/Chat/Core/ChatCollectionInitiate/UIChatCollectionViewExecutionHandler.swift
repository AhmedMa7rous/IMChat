//
//  CollectionViewProtocol.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - ...  Vars
class UIChatCollectionViewExecutionHandler: NSObject, VoiceRecordPlayDataSource {
    weak var dataSource: ChatCollectionViewDataSource?
    weak var delegate: ChatCollectionViewDelegate?
    var audioPlayer: AVAudioPlayer?
    var cell: ChatRecordCell?
    var collectionView: UICollectionView?
    var lastIndex: IndexPath! = IndexPath(row: 0, section: 0)
    var up: Bool = false
}


extension UIChatCollectionViewExecutionHandler {
    func reload() {
        self.collectionView?.IMreloadData {
            if !self.up {
                let count = self.dataSource?.chatMessages.count ?? 0
                self.collectionView?.scrollToItem(at: IndexPath(row: count-1, section: 0), at: .bottom, animated: true)
            } else {
                if self.lastIndex != nil {
                    self.collectionView?.scrollToItem(at: self.lastIndex, at: .top, animated: true)
                }
            }
        }
    }
    func reloadItem() {
        let lastIndex = (self.dataSource?.chatMessages.count ?? 0) - 1
        var indexPathes: [IndexPath] = []
        indexPathes.append(IndexPath(row: lastIndex, section: 0))
        UIView.performWithoutAnimation {
            self.collectionView?.insertItems(at: indexPathes)
            self.collectionView?.reloadItems(at: indexPathes)
            if let path = indexPathes.first {
                self.collectionView?.scrollToItem(at: path, at: .bottom, animated: true)
            }
        }
    }
    func setupMessages(respond: [ChatMessage]) {
        guard let collectionView = collectionView else { return }
        var chats: [ChatMessage] = []
        chats.append(contentsOf: respond)
        //chats.reverse()
        if !self.up {
            var messages = self.dataSource?.collectionView(collectionView, messagesInSection: lastIndex.section)
            messages?.append(contentsOf: chats)
            self.dataSource?.collectionView(collectionView, setMessagesInSection: messages ?? [])
        } else {
            let messages = self.dataSource?.collectionView(collectionView, messagesInSection: lastIndex.section)
            chats.append(contentsOf: messages ?? [])
            self.dataSource?.collectionView(collectionView, setMessagesInSection: chats)
        }
    }
}

// MARK: - ...  Insert Date for message
extension UIChatCollectionViewExecutionHandler {
    func canInsertDate(_ collectionView: UICollectionView, indexPath: IndexPath, forModel model: ChatMessage?) -> Bool {
        var nextMessage: ChatMessage?
        let path = IndexPath(row: indexPath.row+1, section: indexPath.section)
        if path.row == dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section) {
            return false
        }
        nextMessage = self.dataSource?.collectionView(collectionView, cellForItemAt: path)
        if nextMessage?.fromYou == model?.fromYou {
            return false
        } else {
            return true
        }
    }
}

extension UIChatCollectionViewExecutionHandler: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.numberOfSections(in: collectionView) ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.collectionView(collectionView, numberOfItemsInSection: section) ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let kind = self.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) else { return UICollectionViewCell() }
        return self.collectionView(collectionView, cellForItemAt: indexPath, forModel: kind)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, forModel model: ChatMessage?) -> UICollectionViewCell {
        self.lastIndex = indexPath
        var cell: ChatCollectionViewCell?
        switch model?.kind {
            case .text:
                cell = collectionView.IMcell(type: ChatTextCell.self, indexPath)
            case .image:
                cell = collectionView.IMcell(type: ChatImageCell.self, indexPath)
            case .localImage:
                cell = collectionView.IMcell(type: ChatImageCell.self, indexPath)
            case .location:
                cell = collectionView.IMcell(type: ChatLocationCell.self, indexPath)
            case .record:
                cell = collectionView.IMcell(type: ChatRecordCell.self, indexPath)
                if let voice = cell as? ChatRecordCell {
                    voice.path = indexPath.row
                    voice.dataSource = self
                }
            default:
                return UICollectionViewCell()
        }
        cell?.message = model
        if IMChat.setting.visibleDate {
            cell?.insertDateView()
        }
        if IMChat.setting.visibleUserImage {
            cell?.insertUserImageView()
        }
//        if canInsertDate(collectionView, indexPath: indexPath, forModel: model) {
//            cell?.insertDateView()
//        } else {
//            cell?.removeDateView()
//        }
        //cell?.layoutIfNeeded()
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - ...  Collection delegates
extension UIChatCollectionViewExecutionHandler: UICollectionViewDelegateFlowLayout {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let view = dataSource as? UIViewController {
            view.view.endEditing(true)
        }
        if scrollView.contentOffset.y <= 0 {
            self.up = true
            self.delegate?.collectionView(scrollView, reloadTheTop: decelerate)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width , height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
}
