//
//  BoostCell.swift
//  BuySellApp
//
//  Created by Sanzid on 4/5/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit

class BoostCell: UITableViewCell {

    @IBOutlet weak var boostButton: UIButton!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    
    @IBOutlet weak var label2: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCellView.clipsToBounds = true
        backgroundCellView.layer.cornerRadius = 8.0
        
        boostButton.clipsToBounds = true
        boostButton.layer.cornerRadius = 8.0
        
        

        
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
