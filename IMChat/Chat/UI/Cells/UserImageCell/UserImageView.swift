//
//  CategoryStoresModel.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

@IBDesignable
class UserImageView: UIView {
  
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var container: UIView!
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        updateUI()
    }
    
    func xibSetup() {
        view = loadNib()
        self.view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = bounds
        addSubview(view)
        self.frame = CGRect(x: 0, y: 0, width: container.frame.size.width, height: container.frame.size.height)
        // add Constraints
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView": view!]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView": view!]))
    }
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView ?? UIView()
    }
    func updateUI() {
        //userView.cornerRadius = userView.width/2
        //otherView.cornerRadius = otherView.width/2
    }
}
