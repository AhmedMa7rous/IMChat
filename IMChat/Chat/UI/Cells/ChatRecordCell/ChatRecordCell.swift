//
//  ChatRecordCell.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import UIKit
import AVFoundation

class ChatRecordCell: ChatCollectionViewCell {
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var durationLbl: UILabel!
    @IBOutlet weak var durationProgress: UISlider!
    @IBOutlet weak var cellStack: UIStackView!
    
    weak var dataSource: VoiceRecordPlayDataSource?
    var recoredURL: URL?
    var recordDuration: Int?
    var pausedSecond: Int = 0
    var recordRunning: Bool = false
    var timer: TimeHelper?
    var recordMessage: VoiceRecordMessage?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setup() {
        super.setup()
        switch message?.kind {
            case .record(let url):
                let image = self.playBtn.imageView?.image
                let imageStop = self.stopBtn.imageView?.image
                if alignment == .right {
                    self.durationProgress.tintColor = IMChat.setting.rightTextColor
                    self.durationLbl.textColor = IMChat.setting.rightTextColor
                    self.stopBtn.setImage(imageStop?.IMtinted(with: IMChat.setting.leftBackgroundColor), for: .normal)
                    self.playBtn.setImage(image?.IMtinted(with: IMChat.setting.leftBackgroundColor), for: .normal)
                } else {
                    self.durationProgress.tintColor = IMChat.setting.leftTextColor
                    self.durationLbl.textColor = IMChat.setting.leftTextColor
                    self.playBtn.tintColor = IMChat.setting.leftTextColor
                    self.stopBtn.setImage(imageStop?.IMtinted(with: IMChat.setting.rightBackgroundColor), for: .normal)
                    self.playBtn.setImage(image?.IMtinted(with: IMChat.setting.rightBackgroundColor), for: .normal)
                }
                recordMessage = message as? VoiceRecordMessage
                handleRecord(url: url)
            default:
                break
        }
    }
    func handleRecord(url: String?) {
        if self.recordMessage?.recordURL == nil {
            guard let fileURL = url else { return }
            downloadFileFromURL(url: URL(string: fileURL)!) { (url) in
                guard let url = url else { return }
                self.recordMessage?.recordURL = url
                self.recoredURL = url
                self.setupDuration()
            }
        } else {
            self.recoredURL = self.recordMessage?.recordURL!
            self.setupDuration()
        }
        
        if self.dataSource?.getPath() != self.path {
            if self.recordRunning == true {
                self.recordRunning = false
                self.timer?.stopTimer()
                self.timer = nil
                let seconds = self.recordMessage?.seconds
                self.pausedSecond = seconds ?? 0
                self.durationProgress.value = Float(pausedSecond)
                //self.playBtn.setImage(#imageLiteral(resourceName: "7-play"), for: .normal)
            }
        } else {
            if self.timer == nil {
                self.timer = .init(seconds: 1, closure: self.setupSliderDuration(second:))
            }
            self.pausedSecond = Int(self.dataSource?.player()?.currentTime ?? 0)
            self.recordRunning = true
            //self.playBtn.setImage(#imageLiteral(resourceName: "7-play"), for: .normal)
        }
    }
    func setupDuration() {
        if recordMessage?.duration == nil {
            guard let recoredURL = recoredURL else { return }
            let audioAsset = AVURLAsset.init(url: recoredURL, options: nil)
            let duration = audioAsset.duration
            let durationInSeconds = CMTimeGetSeconds(duration)
            self.recordDuration = Int(durationInSeconds)
            recordMessage?.duration = self.recordDuration
        } else {
            recordDuration = recordMessage?.duration ?? 0
        }
        self.setupDurationLbl(second: recordDuration ?? 0)
        durationProgress.maximumValue = Float(recordDuration ?? 0)
        durationProgress.value = Float(pausedSecond)
    }
    func setupSliderDuration(second: Int = 0) {
        pausedSecond += 1
        durationProgress.maximumValue = Float(recordDuration ?? 0)
        durationProgress.value = Float(pausedSecond)
        
        let leftSeconds = (recordDuration ?? 0) - pausedSecond
        setupDurationLbl(second: leftSeconds)
        self.recordMessage?.seconds = pausedSecond
    }
    func setupDurationLbl(second: Int = 0) {
        if second < 0 {
            return
        }
        self.durationLbl.text = second.IMfromatSecondsFromTimer()
    }
    func downloadFileFromURL(url: URL, _ completion: @escaping ((URL?) -> Void)) {
        FileDownloader().loadFileAsync(url: url) { url, error in
            if error == nil {
                completion(url)
            }
        }
    }
    func stopRecord() {
        self.dataSource?.player()?.stop()
        self.pausedSecond = Int(self.dataSource?.player()?.currentTime ?? 0)
        self.timer?.stopTimer()
        self.timer = nil
        self.recordRunning = false
        //self.playBtn.setImage(#imageLiteral(resourceName: "8-2"), for: .normal)
    }
    func runRecord(url: URL) {
        if self.timer == nil {
            self.timer = .init(seconds: 1, closure: self.setupSliderDuration(second:))
        }
        self.dataSource?.play(url: url)
        self.dataSource?.player()?.delegate = self
        self.dataSource?.player()?.prepareToPlay()
        self.dataSource?.player()?.volume = 1.0
        self.dataSource?.player()?.currentTime = Double(self.pausedSecond)
        self.dataSource?.player()?.play()
        self.recordRunning = true
        
    }
    @IBAction func recordDidChange(_ sender: UISlider) {
        pausedSecond = Int(sender.value)
        if recordRunning {
            recordRunning = false
            self.play(playBtn)
        } else {
            setupSliderDuration()
        }
    }
    @IBAction func play(_ sender: UIButton) {
        if self.dataSource?.player()?.url != recoredURL {
            if self.dataSource?.getPath() != self.path {
                if self.dataSource?.getCell()?.recordRunning == true {
                    self.dataSource?.getCell()?.play(UIButton())
                    //self.dataSource?.getCell()?.stop(UIButton())
                }
            }
            self.recordRunning = false
            self.dataSource?.setCell(self)
        }
        guard let url = self.recoredURL else { return }
        
       
        if self.recordRunning {
            self.stopRecord()
            self.stopBtn.isHidden = true
            self.playBtn.isHidden = false
        } else {
            self.runRecord(url: url)
            self.stopBtn.isHidden = false
            self.playBtn.isHidden = true
        }
    }
    @IBAction func stop(_ sender: Any) {
        self.stopRecord()
        self.stopBtn.isHidden = true
        self.playBtn.isHidden = false
    }
}
extension ChatRecordCell: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.dataSource?.player()?.stop()
        timer?.stopTimer()
        timer = nil
        recordRunning = false
        self.pausedSecond = 0
        durationProgress.maximumValue = Float(recordDuration ?? 0)
        durationProgress.value = Float(pausedSecond)
        self.setupDurationLbl(second: recordDuration ?? 0)
        //playBtn.setImage(#imageLiteral(resourceName: "7-play"), for: .normal)
        self.dataSource?.setCell(nil)
        
        self.stopBtn.isHidden = true
        self.playBtn.isHidden = false
    }
}
