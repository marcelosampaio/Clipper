//
//  MainController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 02/06/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class MainController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, InputLocationDelegate {

    
    // MARK: - Propertires
    private var database = Database()
    private let regionRadius: CLLocationDistance = 1000
    private let locationManager = CLLocationManager()
    private var coordinate = CLLocationCoordinate2D()
    private var locations = [LocationRow]()
    
    private var annotations = [MKPointAnnotation]()
    private var rowPointAnnotations = [LocationRowPoint]()
    
//    private var selectedAnnotationView = MKAnnotationView()
    private var selectedLocationRowPoint = LocationRowPoint()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var aimImageView: UIImageView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarButtons()
        
        // send aimView to the front
        view.bringSubviewToFront(aimImageView)

        // prepare database
        database.prepareDatabase()
        
        // initial procedures
        initialProcedures()

        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // get map locations
        getLocations()
        
    }
    
    // MARK: - UI Appearence
    private func navigationBarButtons() {
        ///////// Left
        //create a new button
        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "currentLocation2"), for: UIControl.State.normal)
        
        //add function for button
        button.addTarget(self, action: #selector(self.barButtonPressed), for: .touchUpInside)
        
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        button.clipsToBounds = true
        
        
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    @objc private func barButtonPressed() {
        
        print("🔆 current location button was tapped!")
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
    
    private func getLocations() {
        
        // Remove all previous annotations
        self.mapView.removeAnnotations(annotations)
        annotations.removeAll()
        rowPointAnnotations.removeAll()
        
        locations = database.getLocations()
        
        for location in locations {
            let myAnnotation: MKPointAnnotation = MKPointAnnotation()
            myAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(location.latitude), CLLocationDegrees(location.longitude));
            myAnnotation.title = location.location
            myAnnotation.subtitle = location.reference
            
            mapView.addAnnotation(myAnnotation)  // ⚠️ ATTENTION HERE!!!!!!!! this is for the map
            annotations.append(myAnnotation)
            
            // --------------------------------------------------------------------------
            // 🌟 this is the new class to pass location row to LocationInfoController
            // --------------------------------------------------------------------------
            let rowPointAnnotation = LocationRowPoint()
            rowPointAnnotation.locationAnnotation = myAnnotation
            rowPointAnnotation.locationRow = location
            rowPointAnnotations.append(rowPointAnnotation)
            // ---------------------------------------------------------------------------
            
            print("💥 db location ID: \(location.locationId)")
            print("💥 db location: \(location.location)")
            print("💥 db latitude: \(location.latitude)")
            print("💥 db longitude: \(location.longitude)")
            print("💥 ------------------------------------------ 💥")
        }
        
    }
    

    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "savedLocation")
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("🤞 Callout has been tapped -> \(view.annotation!.title! ?? "")")
//        selectedAnnotationView = view
        
        for rowPoint in rowPointAnnotations {
            if view.annotation!.title! == rowPoint.locationRow.location && view.annotation!.subtitle! == rowPoint.locationRow.reference {
                print("🌟 rowPoint: \(rowPoint)")
                selectedLocationRowPoint = rowPoint
            }
            
        }
        
        
        performSegue(withIdentifier: "showLocationInfo", sender: self)
    }
    
    // MARK: - UI Actions
    @IBAction func prepareNewLocation(_ sender: Any) {
        print("🔸 prepare new location on map")
        performSegue(withIdentifier: "showInput", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showInput" {
            let controller = segue.destination as! InputLocationController
            controller.delegate = self
            controller.coordinate = coordinate
        }else if segue.identifier == "showLocationInfo" {
            let controller = segue.destination as! LocationInfoController
//            controller.annotationView = selectedAnnotationView
            controller.locationRowPoint = selectedLocationRowPoint
        }
    }
    
    // MARK: - Input Location Delegate
    func didSaveNewLocation() {
        // get map locations
        getLocations()
    }
    
    
    
    
}
