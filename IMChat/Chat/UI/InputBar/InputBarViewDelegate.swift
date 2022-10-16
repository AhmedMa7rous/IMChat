//
//  InputBarViewDelegate.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit
import CoreLocation

public protocol InputBarViewDelegate: NSObjectProtocol {
    func InputBarView(inputBar: InputBarView, didPickImage image: UIImage?)
    func InputBarView(inputBar: InputBarView, didPickImageURL url: URL?)
    func InputBarView(inputBar: InputBarView, didWriteText text: String?)
    func InputBarView(inputBar: InputBarView, didPickLocation point: CLLocationCoordinate2D?)
    func InputBarView(inputBar: InputBarView, didPickRecord record: URL?)
    func InputBarView(inputBar: InputBarView, didOpenKeyboard keyboard: Bool?)
    func InputBarView(inputBar: InputBarView, didCloseKeyboard keyboard: Bool?)
    func InputBarView(inputBar: InputBarView) -> UIViewController?
}
public extension InputBarViewDelegate {
    func InputBarView(inputBar: InputBarView, didPickImage image: UIImage?) {
        
    }
    func InputBarView(inputBar: InputBarView, didPickImageURL url: URL?) {
        
    }
    func InputBarView(inputBar: InputBarView, didWriteText text: String?) {
        
    }
    func InputBarView(inputBar: InputBarView, didPickLocation point: CLLocationCoordinate2D?) {
        
    }
    func InputBarView(inputBar: InputBarView, didPickRecord record: URL?) {
        
    }
    func InputBarView(inputBar: InputBarView, didOpenKeyboard keyboard: Bool?) {
        
    }
    func InputBarView(inputBar: InputBarView, didCloseKeyboard keyboard: Bool?) {
        
    }
}
