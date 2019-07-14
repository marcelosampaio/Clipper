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
    private var database = Database()
    private let regionRadius: CLLocationDistance = 1000
    private let locationManager = CLLocationManager()
    private var coordinate = CLLocationCoordinate2D()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare database
        database.prepareDatabase()
        
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
        coordinate = mapView.centerCoordinate
        print("⭐️ center latitude: \(coordinate.latitude)  longitude: \(coordinate.longitude)")
        
        getGeoCode(coordinate)
        
    }
    
    
    
    private func getGeoCode(_ coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location : CLLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            // completion
            if error == nil {
                for placemark in placemarks! {
                    print("📍  locality : \(String(describing: placemark.locality))")
                    print("📍  subLocality : \(String(describing: placemark.subLocality))")
                    print("📍  thoroughfare : \(String(describing: placemark.thoroughfare))")
                    print("📍  subThoroughfare : \(String(describing: placemark.subThoroughfare))")
                    print("📍  region : \(String(describing: placemark.region))")
                    print("📍  postalCode : \(String(describing: placemark.postalCode))")
                    print("📍  country : \(String(describing: placemark.country))")
                    print("📍  timeZone : \(String(describing: placemark.timeZone))")
                    print("📍 ----------------------------------------------------------------------")
                
                    var address = String()
                    var separator = String()
                    if let temp = placemark.locality {
                        address = temp
                        separator = " - "
                    }
                    if let temp = placemark.subLocality {
                        address = address + separator + temp
                    }
                    if let temp = placemark.thoroughfare {
                        address = address + separator + temp
                    }
                    if let temp = placemark.subThoroughfare {
                        address = address + separator + temp
                    }
                    if let temp = placemark.postalCode {
                        address = address + separator + temp
                    }
                    if let temp = placemark.country {
                        address = address + separator + temp
                    }
                    
                    self.addressLabel.text = address
                }
                
                
                
                
            }else{
                // ERROR OCCURRED
                print("🔴 error: \(String(describing: error))")
            }
        }
        
    }
    
    // MARK: - UI Acitions
    
    @IBAction func prepareNewLocation(_ sender: Any) {
        print("🔸 prepare new location on map")
        performSegue(withIdentifier: "showInput", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInput" {
            let controller = segue.destination as! InputLocationController
            controller.coordinate = coordinate
        }
    }
    
}
