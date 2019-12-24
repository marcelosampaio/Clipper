//
//  CommandCell.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 23/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit


class CommandCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        editButton.layer.cornerRadius = 8
        editButton.layer.masksToBounds = true
        editButton.backgroundColor = UIColor.buttonBackgroundColor
        
        deleteButton.layer.cornerRadius = 8
        deleteButton.layer.masksToBounds = true
        deleteButton.backgroundColor = UIColor.destructiveButtonBackgroundColor
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: - UI Actions
    @IBAction func editAction(_ sender: Any) {
        print("EDIT BUTTON ACTION 🌮")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didSelectEditAction"), object: nil)
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        print("DELETE BUTTON ACTION 🌮")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didSelectDeleteAction"), object: nil)
        
    }
    
    
}
