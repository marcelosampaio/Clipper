//
//  TextCell.swift
//  Clipper
//
//  Created by Marcelo Sampaio on 23/12/19.
//  Copyright © 2019 Marcelo Sampaio. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell, UITextViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var titleTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        titleTextView.delegate = self

        // Configure the view for the selected state
    }

    // MARK: - UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        let tagText = TagText()
        if textView.tag == 1000 {
            tagText.tag = 1000
        }else if textView.tag == 1001 {
            tagText.tag = 1001
        }
        tagText.text = textView.text
        print("🅾️ TEXT VIEW ☦️ tag: \(tagText.tag)")
        print("🅾️ tagText tag: \(tagText.tag)")
        // post notification to edit location controller
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didInputLocation"), object: tagText)
    }
    
    
}
