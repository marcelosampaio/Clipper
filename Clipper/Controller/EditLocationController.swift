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
            cell.titleTextView.text = locationRow.location
            cell.titleTextView.backgroundColor = backgroundColor
            cell.titleTextView.layer.cornerRadius = 8
            cell.titleTextView.layer.masksToBounds = true
            return cell
        }else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell") as! LabelCell
            cell.titleLabel.text = "Referência"
            return cell
        }else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextCell") as! TextCell
            cell.titleTextView.text = locationRow.reference
            cell.titleTextView.backgroundColor = backgroundColor
            cell.titleTextView.layer.cornerRadius = 8
            cell.titleTextView.layer.masksToBounds = true
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
        return 0
    }
    
    // MARK: - Gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}
