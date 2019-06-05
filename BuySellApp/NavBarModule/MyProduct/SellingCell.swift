//
//  SellingCell.swift
//  BuySellApp
//
//  Created by Sanzid on 4/4/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit

class SellingCell: UITableViewCell {
    @IBOutlet weak var boostButton: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        productImage.clipsToBounds = true
        productImage.layer.cornerRadius = 8.0
        
        boostButton.clipsToBounds = true
        boostButton.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
