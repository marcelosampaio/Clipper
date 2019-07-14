//
//  LocationRow.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 14/07/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import Foundation

class LocationRow {
    var locationId = Int()
    var location = String()
    var reference = String()
    var latitude = Double()
    var longitude = Double()
    
    init() {
        self.locationId  = Int()
        self.location = String()
        self.reference = String()
        self.latitude = Double()
        self.longitude = Double()
    }
    
    init(locationId: Int, location: String, reference: String, latitude: Double, longitude: Double) {
        self.locationId = locationId
        self.location = location
        self.reference = reference
        self.latitude = latitude
        self.longitude = longitude
    }
    
    
    
    
}
