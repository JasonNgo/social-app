//
//  ShadowView.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-26.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit

@IBDesignable class ShadowView: UIView {
    
    @IBInspectable var shadows: Bool = false {
        didSet {
            setupView()
        }
    }
    
    private func setupView() {
        layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }

}
