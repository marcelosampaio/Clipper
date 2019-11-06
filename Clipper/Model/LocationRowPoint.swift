//
//  LocationRowPoint.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 06/11/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation
import MapKit

class LocationRowPoint {
    
    var locationAnnotation = MKPointAnnotation()
    var locationRow = LocationRow()
    
    init() {
        self.locationAnnotation = MKPointAnnotation()
        self.locationRow = LocationRow()
    }
    
}
