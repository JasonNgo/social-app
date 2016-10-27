//
//  RoundBtn.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-26.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit

@IBDesignable class RoundBtn: UIButton {
    
    private var isRoundedView = false
    
    @IBInspectable var round: Bool = false {
        didSet {
            isRoundedView = true
        }
    }
    
    @IBInspectable var shadow: Bool = false {
        didSet {
            addShadows()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (isRoundedView) {
            roundView()
        }
    }
    private func addShadows() {
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    private func roundView() {
        layer.cornerRadius = self.frame.width / 2
    }

}
