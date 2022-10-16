//
//  VoiceRecordPlayDataSource+Ex.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import AVFoundation

extension VoiceRecordPlayDataSource {
    func setCell(_ cell: ChatRecordCell?) {
        self.cell = cell
    }
    func getCell() -> ChatRecordCell? {
        return cell
    }
    func player() -> AVAudioPlayer? {
        return self.audioPlayer
    }
    func play(url: URL) {
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
    }
    func getPath() -> Int? {
        if self.getCell()?.path != nil {
            return self.getCell()?.path
        } else {
            return -1
        }
    }
}
