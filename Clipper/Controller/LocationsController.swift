//
//  LocationsController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 22/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit

class LocationsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    private var locationRows = [LocationRow]()
    private var database = Database()
    

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getLocations()

    }
 
    // MARK: - TableView Data Source and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! LocationCell
        let locationRow = locationRows[indexPath.row]
        cell.location.text = locationRow.location
        cell.reference.text = locationRow.reference
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEditLocation", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    // MARK: - Location Data Source
    private func getLocations() {
        locationRows = database.getLocations()
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditLocation" {
            let indexPath = tableView.indexPathForSelectedRow
            let locationRow = locationRows[indexPath!.row]
            let controller = segue.destination as! EditLocationController
            controller.locationRow = locationRow
            
        }
    }
    
}
