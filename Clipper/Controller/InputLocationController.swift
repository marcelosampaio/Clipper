//
//  InputLocationController.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 09/07/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit

class InputLocationController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var saveButton: UIButton!
    
    
    
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
    

}
