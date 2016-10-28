//
//  ShadowField.swift
//  social-app
//
//  Created by Jason Ngo on 2016-10-28.
//  Copyright © 2016 Jason Ngo. All rights reserved.
//

import UIKit

@IBDesignable class ShadowField: UITextField {
    
    @IBInspectable var shadows: Bool = false {
        didSet {
            setupView()
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    private func setupView() {
        layer.borderColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
    }
}
