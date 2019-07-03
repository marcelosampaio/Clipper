//
//  MainController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 02/06/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Propertires
    private let regionRadius: CLLocationDistance = 1000
    private let locationManager = CLLocationManager()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // initial procedures
        initialProcedures()

    }

    
    // MARK: - Map Helpers
    private func initialProcedures() {
        
        // User's permissions for the map
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    

    // MARK: - Location Manager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        // stop updating user's location
        locationManager.stopUpdatingLocation()
        
        print("⭐️⭐️⭐️⭐️⭐️ locations = \(locValue.latitude) \(locValue.longitude)")
        
        // init and center map
        let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        centerMapOnLocation(location: initialLocation)
        
    }
    
    
}
