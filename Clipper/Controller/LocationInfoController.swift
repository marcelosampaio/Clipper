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
    
    private var database = Database()
    
    private var pants = [String]()
    private var pant = String()
    
    private var shirts = [String]()
    private var shirt = String()
    
    

    // MARK: - Outlets
    
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var pantsPicker: UIPickerView!
    @IBOutlet weak var shirtsPicker: UIPickerView!
    @IBOutlet weak var commandButton: UIButton!
    
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        commandButton.layer.cornerRadius = 8
        commandButton.layer.masksToBounds = true
        commandButton.layer.borderColor = UIColor.darkGray.cgColor
        commandButton.layer.borderWidth = 1
        
        loadPants()
        loadShirts()
        loadMessage()

    }
    
    // MARK: - Info Helper
    private func loadMessage() {
        var message = String()
        message = "\(timeGreetings()) Estou em "
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
        message.append(", ")
        message.append(shirt)
        
        greetingsLabel.text = message
        
    }

    private func timeGreetings() -> String {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        print("⏰ hour: \(hour)")
        var greetings = String()
        if hour >= 0 && hour <= 11 {
            greetings = "Bom dia."
        }else if hour >= 12 && hour <= 17 {
            greetings = "Boa tarde."
        }else{
            greetings = "Boa noite."
        }
        
        return greetings
    }
    
    
    private func loadPants() {
        pants.append("Calça Jeans")
        pants.append("Short")
        pants.append("Short amarelo")
        pants.append("Short azul")
        pants.append("Calça")
        pants.append("Calça preta")
        pants.append("Calça azul")
        pants.append("Calça cinza")
        
        pantsPicker.delegate = self
        pantsPicker.dataSource = self
        
        pant = pants.first!
        
        
        tableView.reloadData()
    }
    private func loadShirts() {
        shirts.append("camiseta")
        shirts.append("camiseta azul")
        shirts.append("camiseta cinza")
        shirts.append("camiseta vinho")
        shirts.append("camiseta preta")
        shirts.append("camiseta verde")
        shirts.append("camiseta amarela")
        shirts.append("camiseta branca")
        shirts.append("casaco")
        shirts.append("casaco preto")
        shirts.append("casaco cinza")
        shirts.append("casaco branco")
        
        shirtsPicker.delegate = self
        shirtsPicker.dataSource = self
        
        shirt = shirts.first!
        
        tableView.reloadData()
    }
    
    
    // MARK: - UIPickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100 {
            return pants.count
        }else if pickerView.tag == 101 {
            return shirts.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 100 {
            return pants[row]
        }else if pickerView.tag == 101 {
            return shirts[row]
        }
        return ""
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 100 {
            pant = pants[row]
        }else if pickerView.tag == 101 {
            shirt = shirts[row] + "."
        }
        
        
        loadMessage()
        tableView.reloadData()
    }
    
    
    // MARK: - UI Actions
    @IBAction func copyInfoOpenUber(_ sender: Any) {
        
        // copy info to clipboard
        UIPasteboard.general.string = greetingsLabel.text
        
        // open uber app
        if let urlFromStr = URL(string: "uber://") {
            if UIApplication.shared.canOpenURL(urlFromStr) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlFromStr, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(urlFromStr)
                }
            }
        }

        
        
    }
    
    @IBAction func removeAnnotation(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Você tem certaza que deseja remover a localidade?", message: nil, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Remover Localidade", style: .destructive) { (action) in
            self.database.deleteLocation(location: (self.annotationView.annotation?.title!)!, reference: (self.annotationView.annotation?.subtitle!)!, coordinate: self.annotationView.annotation!.coordinate)

            self.navigationController?.popViewController(animated: true)


        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
        }
        
        
    }
    
    
}

