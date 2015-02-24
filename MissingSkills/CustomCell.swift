//
//  CustomCell.swift
//  HackdeOverheid
//
//  Created by Niels Pijpers on 26-01-15.
//  Copyright (c) 2015 UB-online. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    @IBOutlet weak var titleKarweitje: UILabel!
    @IBOutlet weak var descriptionKarweitje: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(leftLabelText: String, description: String) {
        titleKarweitje.text = leftLabelText;
        descriptionKarweitje.numberOfLines = 0;
        descriptionKarweitje.text = String(description);
        
        descriptionKarweitje.sizeToFit();
    }
    
}
