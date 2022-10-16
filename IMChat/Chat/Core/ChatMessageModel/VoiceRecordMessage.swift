//
//  VoiceRecordMessage.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation

public protocol VoiceRecordMessage {
    var recordURL: URL? { get set }
    var seconds: Int? { get set }
    var duration: Int? { get set }
}
