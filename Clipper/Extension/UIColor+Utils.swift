//
//  UIColor+Utils.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 24/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Application Base Color
    class var appTintColor: UIColor {
        get {
            return UIColor.darkGray
        }
    }
    
    // Buttons
    class var buttonBackgroundColor: UIColor {
        get {
            return UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        }
    }
    
    class var destructiveButtonBackgroundColor: UIColor {
        get {
            return UIColor.red
        }
    }
    
    // TextView
    class var textFieldBackgroundColor: UIColor {
        get {
            return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        }
    }

    // backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    
    
    
    class func placeHolderColor(placeHolderText: String, textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: placeHolderText,attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.8)])
    }
    
}

