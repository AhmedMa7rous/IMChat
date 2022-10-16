//  GalleryPickerHelper
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import UIKit
import MobileCoreServices
import AVFoundation

internal final class IMGalleryPickerHelper: NSObject, IMGalleryPickerHelper.VideoPickerDelegate {
    internal typealias VideoPickerDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate
    
    internal enum PickingType {
        case picture, video
    }
    
    private var picker: UIImagePickerController?
    var documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)

    internal var onPickImage: ((UIImage) -> Void)?,
    onPickImageURL: ((URL?) -> Void)?,
    onPickImageData: ((Data?) -> Void)?,
    onCancel: (() -> Void)?,
    placeholderImage = UIImage(),
    alertTitle, alertMessage: String?,
    tintColor = UIColor.darkGray,
    cameraTitle = "Camera".IMlocalized, libraryTitle = "Photo library".IMlocalized, cancelTitle = "Cancel".IMlocalized,
    onError: (() -> Void)?,
    onPickVideoURL: ((URL) -> Void)?

    internal func pick(in screen: UIViewController?, type: PickingType = .picture) {
        picker = UIImagePickerController()
        picker?.delegate = self
        picker?.allowsEditing = true
        picker?.mediaTypes = [ type == .picture ? kUTTypeImage as String : kUTTypeMovie as String]
        let alert = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        alert.view.layer.cornerRadius = 4.0
        alert.view.tintColor = tintColor
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: { [weak self] (_) in
            NSLog("tell user something in `onCancel` block because he cancel picking")
            self?.onCancel?()
            self?.onCancel = .none
        }))
        alert.addAction(cameraAction(in: screen))
        alert.addAction(libraryAction(in: screen))
        screen?.present(alert, animated: true)
    }
    private func cameraAction(in screen: UIViewController?) -> UIAlertAction {
        return UIAlertAction(title: cameraTitle, style: .default, handler: { [weak self] (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
                NSLog("tell user something in `onError` block because camera not available")
                self?.onError?()
                self?.onError = .none
                return
            }
            self?.picker?.sourceType = .camera
            guard let picker = self?.picker else {
                NSLog("use `onError` block because ImagePicker is null")
                self?.onError?()
                self?.onError = .none
                return
            }
            screen?.present(picker, animated: true)
        })
    }
    private func libraryAction(in screen: UIViewController?) -> UIAlertAction {
        return UIAlertAction(title: libraryTitle, style: .default, handler: { [weak self] (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
                NSLog("tell user something in `onError` block because photoLibrary not available")
                self?.onError?()
                self?.onError = .none
                return
            }
            self?.picker?.sourceType = .photoLibrary
            guard let picker = self?.picker else {
                NSLog("use `onError` block because ImagePicker is null")
                self?.onError?()
                self?.onError = .none
                return
            }
            screen?.present(picker, animated: true)
        })
    }

    internal func getThumbnailImage(for url: URL) -> UIImage? {
        let asset = AVAsset.init(url: url)
        let imageGenerator = AVAssetImageGenerator.init(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        guard let cgImage = try? imageGenerator.copyCGImage(at: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
                                                            actualTime: .none) else { return .none }
        return UIImage.init(cgImage: cgImage)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        NSLog("tell user something in `onCancel` block because he cancel picking")
        picker.dismiss(animated: true, completion: onCancel)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            onPickVideoURL?(videoURL)
        } else {
            var pickedImage = placeholderImage
            if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                pickedImage = editedImage
            } else if let originalPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                pickedImage = originalPhoto
            }
            NSLog("user picking image you can find it in `onPickImage` block")
            onPickImage?(pickedImage)
            onPickImageURL?(getImageURL(image: pickedImage))
        }
        picker.dismiss(animated: true)
    }
    func getImageURL(image: UIImage) -> URL? {
        var photoURL: URL?
        saveImage(image: image, name: "COMPRESSED_IMAGE.png")
        photoURL = getSavedImage(named: "COMPRESSED_IMAGE.png")
        
        //photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
        
        return photoURL
    }
    func saveImage(image: UIImage, name: String? = "fileName.png") {
        guard let data = image.jpegData(compressionQuality: 0.5) as NSData? else { return }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else { return }
        do {
            try data.write(to: directory.appendingPathComponent(name ?? "")!)
        } catch {
            print(error.localizedDescription)
        }
    }
    func getSavedImage(named: String) -> URL? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named)
        }
        return nil
    }

}
