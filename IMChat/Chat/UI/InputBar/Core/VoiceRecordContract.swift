//
//  VoiceRecordHandlerContract.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
import AVFoundation

protocol VoiceRecordContract: AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func onStart()
    func onCancel()
    func onFinished(duration: CGFloat)
    func onFinished() -> URL?
}
