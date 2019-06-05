//
//  CategoeryCell.swift
//  BuySellApp
//
//  Created by Sanzid on 3/16/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit

class CategoeryCell: UICollectionViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameTitle: UILabel!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imagesMain: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        imagesMain.clipsToBounds = true
        imagesMain.layer.cornerRadius = imagesMain.frame.height/2
//        imagesMain.layer.borderColor = UIColor(rgba:"#6747CE").withAlphaComponent(0.7).cgColor
//        imagesMain.layer.borderWidth = 0.5
        
        // Initialization code
    }
    override var isSelected: Bool {
        didSet {
            // set color according to state
            //self.contentView.backgroundColor = self.isSelected ? UIColor.green.withAlphaComponent(0.5) : .clear
            self.nameTitle.textColor = self.isSelected ? UIColor.red : UIColor.lightGray
           // self.logoImage.image = self.logoImage.image?.maskWithColor(color: UIColor.red)
            
        }
    }

}
