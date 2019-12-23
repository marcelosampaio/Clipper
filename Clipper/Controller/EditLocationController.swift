//
//  EditLocationController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 23/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class EditLocationController: UIViewController {

    // MARK: - Properties
    public var locationRow = LocationRow()
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        print("☢️ location Row: \(locationRow)")
        
    }
    


}
