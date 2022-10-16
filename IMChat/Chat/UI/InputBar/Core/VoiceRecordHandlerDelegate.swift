//
//  RecordViewDelegate.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import UIKit

protocol VoiceRecordHandlerDelegate: AnyObject {
    func voiceRecordHandler(_ handler: VoiceRecordHandler?, observeDuration duration: CGFloat)
}
