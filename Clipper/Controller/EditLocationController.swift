//
//  EditLocationController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 23/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

// MARK: - Prototols
protocol EditLocationDelegate: class {
    func willRefreshMapData()
}


class EditLocationController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {


    // MARK: - Properties
    public var locationRow = LocationRow()
    
    private var source = [String]()
    private var database = Database()
    
    // map support
    private let regionRadius: CLLocationDistance = 1000
    private var rowPointAnnotations = [LocationRowPoint]()
    private var annotations = [MKPointAnnotation]()
    
    // delegate
    weak var delegate: EditLocationDelegate?
    
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMapSupport()
        
        observerManager()
        tableView.delegate = self
        tableStructure()
        print("☢️ location Row: \(locationRow)")
        
    }
    
    // MARK: - View Table Structure
    private func tableStructure() {
        source.append("LabelCell")  // Localidade Label
        source.append("TextCell")   // Localidade Text
        source.append("LabelCell")  // Reference Label
        source.append("TextCell")   // Reference Text
        source.append("CommandCell") // 2 buttons
        
        tableView.reloadData()
        
    }
    
    // MARK: - TableView DataSource and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! LabelCell
            cell.titleLabel.text = "Localidade"
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
            cell.titleTextView.tag = 1000
            cell.titleTextView.text = locationRow.location
            cell.titleTextView.backgroundColor = UIColor.textFieldBackgroundColor
            cell.titleTextView.layer.cornerRadius = 8
            cell.titleTextView.layer.masksToBounds = true
            cell.titleTextView.autocorrectionType = .no
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! LabelCell
            cell.titleLabel.text = "Referência"
            return cell
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
            cell.titleTextView.tag = 1001
            cell.titleTextView.text = locationRow.reference
            cell.titleTextView.backgroundColor = UIColor.textFieldBackgroundColor
            cell.titleTextView.layer.cornerRadius = 8
            cell.titleTextView.layer.masksToBounds = true
            cell.titleTextView.autocorrectionType = .no
            return cell
        }else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommandCell") as! CommandCell
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 21
        }else if indexPath.row == 1 {
            return 79
        }else if indexPath.row == 2 {
            return 21
        }else if indexPath.row == 3 {
            return 79
        }else if indexPath.row == 4 {
            return 80
        }
        return 100
    }
    
    // MARK: - Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Observers
    private func observerManager() {
        removelAllObservers()
        
        // button action
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectEditAction(_:)),
                                               name: NSNotification.Name(rawValue: "didSelectEditAction"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didSelectDeleteAction(_:)),
                                               name: NSNotification.Name(rawValue: "didSelectDeleteAction"),
                                               object: nil)
        
        // data entry edit
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didInputLocation(_:)),
                                               name: NSNotification.Name(rawValue: "didInputLocation"),
                                               object: nil)
        
        
    }
    private func removelAllObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didSelectEditAction"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didSelectDeleteAction"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didInputLocation"), object: nil)
    }
    
    
    @objc private func didSelectEditAction(_ sender: NSNotification) {
        if isValidDataEntry() {
            
            // update database info
            database.updateLocation(location: locationRow.location, reference: locationRow.reference, id: locationRow.locationId)
            
            // call back main caller
            delegate?.willRefreshMapData()
            
            // dismiss viw controller
            self.dismiss(animated: true, completion: nil)
            
        }
        view.alert(msg: "Informe localidade!", sender: self)
    }
    
    @objc private func didSelectDeleteAction(_ sender: NSNotification) {
        print("🥁🥁🥁🥁🥁🥁🥁 didSelectDeleteAction: \(locationRow)")
        
        // remove database info
        database.deleteLocationById(id: locationRow.locationId)
        
        // call back main caller
        delegate?.willRefreshMapData()
        
        // dismiss viw controller
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc private func didInputLocation(_ sender: NSNotification) {
        let tagText = sender.object as! TagText
        if tagText.tag == 1000 {
            print("🅾️ location: \(tagText.text)")
            locationRow.location = tagText.text
        }else if tagText.tag == 1001 {
            locationRow.reference = tagText.text
            print("🅾️ reference: \(tagText.text)")
        }

    }
    
    
    // MARK: - Data Entry Helper
    private func isValidDataEntry() -> Bool {
        if !locationRow.location.isValidName()! {
            view.alert(msg: "Informe o nome da localidade!", sender: self)
            return false
        }
        print("🎸 updated location row: \(locationRow)")

        return true
    }
    
    // MARK: - MapKit Delegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            return nil
        }

        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)

        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = false
//            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        }
        else {
            annotationView!.annotation = annotation
        }

        let pinImage = UIImage(named: "savedLocation")
        annotationView!.image = pinImage
        
        return annotationView
    }
    
    // MARK: - Map Helper
    private func prepareMapSupport() {
        mapView.delegate = self
        mapView.isUserInteractionEnabled = false
        
        mapView.layer.cornerRadius = 8
        mapView.layer.masksToBounds = true
        
        /////////
        let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(locationRow.latitude), CLLocationDegrees(locationRow.longitude));
        myAnnotation.title = locationRow.location
        myAnnotation.subtitle = locationRow.reference
        
        mapView.addAnnotation(myAnnotation)  // ⚠️ ATTENTION HERE!!!!!!!! this is for the map
        annotations.append(myAnnotation)
        
        // --------------------------------------------------------------------------
        // 🌟 this is the new class to pass location row to LocationInfoController
        // --------------------------------------------------------------------------
        let rowPointAnnotation = LocationRowPoint()
        rowPointAnnotation.locationAnnotation = myAnnotation
        rowPointAnnotation.locationRow = locationRow
        rowPointAnnotations.append(rowPointAnnotation)
        // ---------------------------------------------------------------------------
        /////////
        
        
        // mapView.showAnnotations(mapView.annotations, animated: true)
        
        // init and center map
        let initialLocation = CLLocation(latitude: locationRow.latitude, longitude: locationRow.longitude)
        centerMapOnLocation(location: initialLocation)
    }
    private func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
