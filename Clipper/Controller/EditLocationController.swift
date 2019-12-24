//
//  EditLocationController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 23/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit
import MapKit

class EditLocationController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    // MARK: - Properties
    public var locationRow = LocationRow()
    
    private var source = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.isUserInteractionEnabled = false
        observerManager()
        tableView.delegate = self
        tableStructure()
        print("☢️ location Row: \(locationRow)")
        
    }
    
    // MARK: View Table Structure
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
        let backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! LabelCell
            cell.titleLabel.text = "Localidade"
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
            cell.titleTextView.tag = 1000
            cell.titleTextView.text = locationRow.location
            cell.titleTextView.backgroundColor = backgroundColor
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
            cell.titleTextView.backgroundColor = backgroundColor
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
            print("..... 🎫:")
        }
        print("🎷🎷🎷🎷🎷🎷🎷 didSelectEditAction: \(locationRow)")
    }
    
    @objc private func didSelectDeleteAction(_ sender: NSNotification) {
        print("🥁🥁🥁🥁🥁🥁🥁 didSelectDeleteAction: \(locationRow)")
    }
    
    
    @objc private func didInputLocation(_ sender: NSNotification) {
        let tagText = sender.object as! TagText
        if tagText.tag == 1000 {
            locationRow.location = tagText.text
        }else if tagText.tag == 1001 {
            locationRow.reference = tagText.text
        }

    }
    
    
    // MARK: - Data Entry Helper
    private func isValidDataEntry() -> Bool {
        
        print("🎸 updated location row: \(locationRow)")

        return true
    }
    
}
