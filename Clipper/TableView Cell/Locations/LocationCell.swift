//
//  LocationCell.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 23/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var reference: UILabel!
    @IBOutlet weak var separatorView: UIView!
    

    // MARK: - Others
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        separatorView.alpha = 0.2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
