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
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var diffi: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setCell(leftLabelText: String, description: String, coins: String, deadline: String, grade: String) {
        titleKarweitje.text = leftLabelText;
        descriptionKarweitje.numberOfLines = 0;
        descriptionKarweitje.text = String(description);
        descriptionKarweitje.sizeToFit();
        coinLabel.text = String(coins)
        deadlineLabel.text = String(deadline)
        
        switch(grade) {
            case "hard":
                diffi.image = UIImage(named: "hard.png");
                break;
            case "medium":
                diffi.image = UIImage(named: "medium.png");
                break;
            case "easy":
                diffi.image = UIImage(named: "easy.png");
                break;
        default:
            break;
        }
    }
    
}
