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
    private var source = [String]()
    

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
 
    // mARK: - TableView Data Source and Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = source[indexPath.row]
        return cell!
    }
    
    
}
