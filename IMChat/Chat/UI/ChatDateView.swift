//
//  CategoryStoresModel.swift
//  IMChat
//
//  Created by Ma7rous on 16/10/2022.
//

import Foundation
import UIKit

@IBDesignable
class ChatDateView: UIView {
  
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var dateLbl: UILabel!
    //@IBOutlet var otherView: GradientView!
    //@IBOutlet var userView: UIView!
    //@IBOutlet weak var userImage: UIImageView!
    @IBOutlet var container: UIView!
    
    var view: UIView!
    private var containerAlignment: Chat.Direction = .left
    var alignment: Chat.Direction {
        get {
            return containerAlignment
        } set {
            containerAlignment = newValue
            setupAlignment()
            updateUI()
        }
    }
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
    func setupAlignment() {
        leadingConstraint.isActive = false
        if alignment == .left {
            dateLbl.textAlignment = .left
            leadingConstraint = NSLayoutConstraint(item: leadingConstraint.firstItem as Any,
                                                attribute: .trailing,
                                                relatedBy: leadingConstraint.relation,
                                                toItem: leadingConstraint.secondItem,
                                                attribute: .trailing, multiplier: leadingConstraint.multiplier,
                                                constant: leadingConstraint.constant)
        } else {
            dateLbl.textAlignment = .right
            leadingConstraint = NSLayoutConstraint(item: leadingConstraint.firstItem as Any,
                                                attribute: .leading,
                                                relatedBy: leadingConstraint.relation,
                                                toItem: leadingConstraint.secondItem,
                                                attribute: .leading, multiplier: leadingConstraint.multiplier,
                                                constant: -leadingConstraint.constant)
        }
        leadingConstraint.isActive = true
    }
}
