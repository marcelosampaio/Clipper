//
//  MainController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 02/06/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
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
        
        // For MKMapViewDelegate usage
        mapView.delegate = self
        
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
        
        print("⭐️ locations = \(locValue.latitude) \(locValue.longitude)")
        
        // init and center map
        let initialLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        centerMapOnLocation(location: initialLocation)
        
    }
    
    // MARK: - MKMapViewDelegate Delegate
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = mapView.centerCoordinate
        print("⭐️ center latitude: \(center.latitude)  longitude: \(center.longitude)")
        
        getGeoCode(center)
        
    }
    
    
    
    private func getGeoCode(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
    
        let latitude : CLLocationDegrees = coordinate.latitude
        let logintude : CLLocationDegrees = coordinate.longitude
        
        let location : CLLocation = CLLocation(latitude: latitude, longitude: logintude)
        

        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // completion
            if error == nil {
                for placemark in placemarks! {
                    print("📍  locality : \(String(describing: placemark.locality))")
                    print("📍  subLocality : \(String(describing: placemark.subLocality))")
                    print("📍  thoroughfare : \(String(describing: placemark.thoroughfare))")
                    print("📍  subThoroughfare : \(String(describing: placemark.subThoroughfare))")
                    print("📍  region : \(String(describing: placemark.region))")
                    print("📍 ----------------------------------------------------------------------")
                }
                
                
                
                
            }else{
                // ERROR OCCURRED
                print("🔴 error: \(String(describing: error))")
            }
        }
        
    }
    
    
    //////
    /*
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        // Use the last reported location.
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
            
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
                                            completionHandler: { (placemarks, error) in
                                                if error == nil {
                                                    let firstLocation = placemarks?[0]
                                                    completionHandler(firstLocation)
                                                }
                                                else {
                                                    // An error occurred during geocoding.
                                                    completionHandler(nil)
                                                }
            })
        }
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    */
    
}
