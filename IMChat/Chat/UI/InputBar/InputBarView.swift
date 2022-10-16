//
//  CategoryStoresModel.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
import CoreLocation

@IBDesignable
public class InputBarView: UIView {
 
    @IBOutlet weak var container: UIView!
    //@IBOutlet weak var miceImage: UIImageView!
    @IBOutlet weak var inputTxv: UITextView!
    @IBOutlet public weak var inputHeight: NSLayoutConstraint!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var moreStack: UIStackView!
    //@IBOutlet weak var locationBtn: UIButton!
    //@IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var voiceBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cancelView: UIView!
    @IBOutlet weak var sendImage: UIImageView!
    @IBOutlet weak var attachmentImage: UIImageView!
    
    public weak var delegate: InputBarViewDelegate?
    public var textViewLocalizedString: String = "" {
        didSet {
            inputTxv.text = textViewLocalizedString
            if IM.setting.language == "ar" {
                inputTxv.textAlignment = .right
            }
        }
    }
    
    private var messageType: Chat.Kind?
    private var keyboardHeight: CGFloat = 0
    private var image: UIImage?
    private var imageURL: URL?
    private var view: UIViewController? {
        get {
            self.delegate?.InputBarView(inputBar: self)
        }
    }
    lazy var voiceRecord: VoiceRecordHandler? = {
       let voice = VoiceRecordHandler()
        voice.delegate = self
        return voice
    }()
    lazy var imagePicker: IMGalleryPickerHelper? = {
        let picker = IMGalleryPickerHelper()
        picker.onPickImage = { [weak self] image in
            self?.image = image
        }
        picker.onPickImageURL = { [weak self] url in
            guard let url = url else { return }
            self?.sendImage.isHidden = false
            self?.attachmentImage.isHidden = true
            self?.messageType = .image(url.absoluteString)
            self?.imageURL = url
            self?.send(url)
        }
        return picker
    }()
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
}

// MARK: - ...  initiate
extension InputBarView {
    func initNib() {
        let bundle = Bundle(for: InputBarView.self)
        bundle.loadNibNamed("InputBarView", owner: self, options: nil)
        addSubview(container)
        container.frame = bounds
        container.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView": container!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView": container!]))
        updateView()
    }
}
// MARK: - ...  Functions
extension InputBarView {
    func updateView() {
        //miceImage.isHidden = true
        cancelView.isHidden = true
        attachmentImage.isHidden = true
        sendImage.isHidden = false
        inputTxv.delegate = self
    }
    func writeMessage() {
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut) {
            //self.miceImage.isHidden = true
            //self.locationBtn.isHidden = true
            //self.cameraBtn.isHidden = true
            //self.voiceBtn.isHidden = true
            self.cancelView.isHidden = false
            self.attachmentImage.isHidden = true
            self.sendImage.isHidden = false
            self.layoutIfNeeded()
        }
    }
    func record() {
        messageType = .record("")
        inputTxv.text = ""
        inputTxv.textColor = IMChat.setting.textColor
        inputTxv.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseInOut) {
            //self.miceImage.isHidden = false
            //self.locationBtn.isHidden = true
            //self.cameraBtn.isHidden = true
            //self.voiceBtn.isHidden = true
            self.cancelView.isHidden = false
            self.attachmentImage.isHidden = true
            self.sendImage.isHidden = false
            self.layoutIfNeeded()
        }
    }
    func resetInput() {
        messageType = nil
        inputTxv.text = textViewLocalizedString
        textViewDidChange(inputTxv)
        if #available(iOS 13.0, *) {
            inputTxv.textColor = .placeholderText
        }
        inputTxv.isUserInteractionEnabled = true
        inputTxv.endEditing(true)
        self.cancelView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            //self.locationBtn.isHidden = false
            //self.cameraBtn.isHidden = false
            //self.voiceBtn.isHidden = false
            //self.miceImage.isHidden = true
            self.attachmentImage.isHidden = true
            self.sendImage.isHidden = false
            self.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
}

// MARK: - ...  Actions
extension InputBarView {
    @IBAction func send(_ sender: Any) {
        if sendImage.isHidden {
            camera(sender)
            return
        }
        inputTxv.endEditing(true)
        if (messageType == nil) && (!inputTxv.text.isEmpty && inputTxv.text != textViewLocalizedString) {
            messageType = .text(inputTxv.text)
        }
        switch messageType {
        case .text:
            self.delegate?.InputBarView(inputBar: self, didWriteText: inputTxv.text)
        case .location(let lat, let lng):
            self.delegate?.InputBarView(inputBar: self, didPickLocation: CLLocationCoordinate2D(latitude: lat ?? 0, longitude: lng ?? 0))
        case .image:
            self.delegate?.InputBarView(inputBar: self, didPickImage: image)
            self.delegate?.InputBarView(inputBar: self, didPickImageURL: imageURL)
        case .record:
            self.delegate?.InputBarView(inputBar: self, didPickRecord: voiceRecord?.onFinished())
        default:
            break
        }
        
        voiceRecord?.onCancel()
        resetInput()
    }
    @IBAction func location(_ sender: Any) {
        //        guard let scene = R.storyboard.sendLocationStoryboard.sendLocationVC() else { return }
        //        scene.delegate = self
        //        view?.navigationController?.pushViewController(scene)
    }
    @IBAction func camera(_ sender: Any) {
        imagePicker?.pick(in: view)
    }
    @IBAction func voice(_ sender: Any) {
        record()
        voiceRecord?.onStart()
    }
    @IBAction func voiceCancel(_ sender: Any) {
        messageType = nil
        voiceRecord?.onCancel()
        resetInput()
    }
}
//extension InputBarView: SendLocationViewDelegate {
//    func sendLocation(_ delegate: SendLocationViewDelegate?, point: CLLocationCoordinate2D) {
//        messageType = .location(point.latitude, point.longitude)
//        send(self)
//    }
//}

extension InputBarView: UITextViewDelegate {
    func updateBottomConstraint(_ enable: Bool = true) {
        if let bottomConstraint = self.constraints.first(where: { $0.firstAttribute == .bottom }) {
            if enable {
                bottomConstraint.constant += keyboardHeight
                self.delegate?.InputBarView(inputBar: self, didOpenKeyboard: true)
            } else {
                bottomConstraint.constant -= keyboardHeight
                self.delegate?.InputBarView(inputBar: self, didCloseKeyboard: true)
            }
        }
    }
    public func textViewDidEndEditing(_ textView: UITextView) {
        updateBottomConstraint(false)
        if textView.text.isEmpty || textView.text == textViewLocalizedString {
            resetInput()
            textView.text = textViewLocalizedString
            if #available(iOS 13.0, *) {
                textView.textColor = .placeholderText
            } else {
                // Fallback on earlier versions
            }
        } else {
            writeMessage()
            textView.textColor = IMChat.setting.textColor
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        updateBottomConstraint(true)
        if textView.text == textViewLocalizedString {
            textView.text = ""
        }
        textView.textColor = IMChat.setting.textColor
        writeMessage()
    }
    public func textViewDidChange(_ textView: UITextView) {
        var textHeight = textView.text.IMheightWithConstrainedWidth(width: textView.frame.size.width, font: textView.font ?? .systemFont(ofSize: 15))
        if textHeight > 150 {
            textHeight = 150
        }
        if textHeight <= 45 {
            inputHeight.constant = 45
        } else {
            inputHeight.constant = textHeight + 20
        }
    }
}

extension InputBarView: VoiceRecordHandlerDelegate {
    func voiceRecordHandler(_ handler: VoiceRecordHandler?, observeDuration duration: CGFloat) {
        print(duration)
        inputTxv.text = duration.fromatSecondsFromTimer()
    }
}
