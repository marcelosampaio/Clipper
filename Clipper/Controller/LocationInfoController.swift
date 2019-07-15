//
//  LocationInfoController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 15/07/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class LocationInfoController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    
    // MARK: - Properties
    public var annotationView = MKAnnotationView()
    
    private var pants = [String]()
    private var pant = String()
    

    // MARK: - Outlets
    
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var pantsPicker: UIPickerView!
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadPants()
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
        message.append(". ")
        
        // pants
        message.append(pant)
        
        greetingsLabel.text = message
        
    }

    private func loadPants() {
        pants.append("Jeans")
        pants.append("Calça")
        pants.append("Short")
        pants.append("Short amarelo")
        pants.append("Short azul")
        
        pantsPicker.delegate = self
        pantsPicker.dataSource = self
        
        pant = pants.first!
        
        
        tableView.reloadData()
    }

    // MARK: - UIPickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100 {
            return pants.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 100 {
            return pants[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pant = pants[row] + ", "
        
        loadMessage()
        tableView.reloadData()
    }
}
