//
//  VoiceRecordPlay.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import AVFoundation


protocol VoiceRecordPlayDataSource: AnyObject {
    var audioPlayer: AVAudioPlayer? { get set }
    var cell: ChatRecordCell? { get set }
    func player() -> AVAudioPlayer?
    func getCell() -> ChatRecordCell?
    func getPath() -> Int?
    func setCell(_ cell: ChatRecordCell?)
    func play(url: URL)
}
