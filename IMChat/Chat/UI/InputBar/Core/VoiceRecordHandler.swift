//
//  LocationMessageHandler.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
import AVFoundation

class VoiceRecordHandler: NSObject, VoiceRecordContract {
    private var recordingSession: AVAudioSession!
    private var audioRecorder: AVAudioRecorder!
    private var timer: TimeHelper?
    private var duration: CGFloat = 0
    private var isStarted: Bool = false
    private var randomName: String = "recording"
    weak var delegate: VoiceRecordHandlerDelegate?
}
extension VoiceRecordHandler {

    private func createTimer() {
        timer = .init(seconds: 1, closure: { [weak self] second in
            self?.duration += 1
            self?.delegate?.voiceRecordHandler(self, observeDuration: self?.duration ?? 0)
        })
    }
    
    private func setupRecord() {
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission { allowed in
                DispatchQueue.main.async {
                    if allowed {
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    private func startRecording() {
        if isStarted {
            return
        }
        isStarted = true
        setupRecord()
        randomName = String().randomString(length: 8)
        let audioFilename = getFileURL()
        print(audioFilename)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            createTimer()
        } catch {
            finishRecording()
        }
    }
    
    private func finishRecording() {
        if audioRecorder != nil {
            audioRecorder.stop()
            audioRecorder = nil
            try? recordingSession.setCategory(.playback)
            recordingSession = nil
            timer?.stopTimer()
            timer = nil
            duration = 0
            isStarted = false
        }
        
    }
 
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("\(randomName).m4a")
        return path as URL
    }
}

extension VoiceRecordHandler {
    // MARK: - ...  delegates
    internal func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    internal func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
}
extension VoiceRecordHandler {
    internal func onStart() {
        print("record On Start")
        startRecording()
    }
    
    internal func onCancel() {
        print("record on Cancel")
        finishRecording()
    }
    internal func onFinished() -> URL? {
        if duration > 1 {
            let url = getFileURL()
            finishRecording()
            return url
        } else {
            finishRecording()
        }
        return nil
    }
    internal func onFinished(duration: CGFloat) {
        if duration > 1 {
            finishRecording()
            print("duration \(duration)")
            let url = getFileURL()
            print(url.path)
        } else {
            finishRecording()
        }
    }
}
