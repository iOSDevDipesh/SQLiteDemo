//
//  UIView+Extension.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import UIKit

@IBDesignable extension UIView {
    
    @IBInspectable
    var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        
        get {
            guard let color = layer.borderColor else { return nil }
            
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue?.cgColor
        }
        
        get {
            guard let color = layer.shadowColor else { return nil }
            
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        
        get {
            return layer.shadowOffset
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        
        get {
            return layer.shadowRadius
        }
    }
}
