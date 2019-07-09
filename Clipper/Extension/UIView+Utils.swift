//
//  UIView+Utils.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 09/07/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit


extension UIView {
    
    
    
    // MARK: - Alert Controller
    func alert(msg: String, sender: UIViewController) {
        let alertController = UIAlertController(title: msg, message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
        }
        alertController.addAction(okAction)
        sender.present(alertController, animated: true) {
        }
    }
    
    
    // MARK: - HUD
    func showActivityLoading() {
        let shadowView = UIView(frame:CGRect(x: 0, y:0, width: 90, height:90))
        shadowView.center = self.center
        shadowView.layer.cornerRadius = 8
        shadowView.layer.masksToBounds = true
        
        shadowView.tag = -998;
        shadowView.backgroundColor = UIColor.darkGray
        
        
        let activity = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activity.center = self.center
        activity.tag = -999
        
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(shadowView)
        
        self.addSubview(shadowView)
        self.addSubview(activity)
        activity.startAnimating()
    }
    
    func hideActivityLoading() {
        DispatchQueue.main.async {
            self.alpha = 1.0
            self.viewWithTag(-998)?.removeFromSuperview()
            self.viewWithTag(-999)?.removeFromSuperview()
        }
    }
    
    
}

