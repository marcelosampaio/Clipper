//
//  InputLocationController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 09/07/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class InputLocationController: UIViewController {
    
    // MARK: - Properties
    public var coordinate = CLLocationCoordinate2D()
    
    private var database = Database()
    

    // MARK: - Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var reference: UITextField!
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

//        saveButton.layer.cornerRadius = 8
//        saveButton.layer.masksToBounds = true
//        saveButton.layer.borderColor = UIColor.lightGray.cgColor
//        saveButton.layer.borderWidth = 0.45

        
    }
    
    
    // MARK: - UI Actions
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if !location.text!.isValidName()! {
            view.alert(msg: "Informe o nome da localidade!", sender: self)
            return
        }
        
        print("🧨 SAVE ACTION")
        
        
        database.addLocation(location: location.text!, reference: reference.text!, coordinate: coordinate)
        
        
        
        // dismiss view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
