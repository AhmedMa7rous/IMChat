//
//  ChatLocationCell.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import UIKit
import CoreLocation
class ChatLocationCell: ChatCollectionViewCell {
    @IBOutlet weak var locationImage: UIImageView!
    
    var lat: Double?
    var lng: Double?
    override func awakeFromNib() {
        super.awakeFromNib()
        handleMap()
        // Initialization code
    }
    override func setup() {
        super.setup()
        setupCorners(view: locationImage)
        switch message?.kind {
            case .location(let lat, let lng):
                self.lat = lat
                self.lng = lng
                locationImage.locationImage(lat: lat, lng: lng)
            default:
                break
        }
    }
    func handleMap() {
//        locationImage.UIViewAction {
//            self.openMapForLocation(delegate: UIApplication.topViewController(), location: CLLocationCoordinate2D(latitude: self.lat ?? 0, longitude: self.lng ?? 0))
//        }
    }
}


extension UIImageView {
    func locationImage(lat: Double?, lng: Double?) {
        if let lat = lat, let lng = lng {
            let url = "http://maps.google.com/maps/api/staticmap?center=\(lat),\(lng)&zoom=14&size=400x400&markers=\(lat),\(lng) &sensor=false&key=\(IMChat.setting.GOOGLE_API_KEY)"
            downloadIMChat(url: url)
        }
    }
}
