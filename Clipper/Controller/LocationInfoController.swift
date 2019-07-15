//
//  LocationInfoController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 15/07/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class LocationInfoController: UITableViewController {
    
    // MARK: - Properties
    public var annotationView = MKAnnotationView()
    
    

    // MARK: - Outlets
    
    @IBOutlet weak var greetingsLabel: UILabel!
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMessage()
        
    }
    
    // MARK: - Info Helper
    private func loadMessage() {
        var message = String()
        message = "Boa tarde! Estou em "
        if let location = annotationView.annotation?.title! {
            message.append(location)
        }
        if let reference = annotationView.annotation?.subtitle! {
            if !reference.isEmpty {
                message.append(", ")
                message.append(reference)
            }
            
        }
        message.append(".")
        greetingsLabel.text = message
        
    }



}
