//
//  FooterView.swift
//  Keeno
//
//  Created by Sanzid on 4/25/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit

class FooterView: UICollectionReusableView {
    
    
    @IBOutlet weak var footerImage: UIImageView!
    
    override func awakeFromNib() {
        
        footerImage.clipsToBounds = true
        footerImage.backgroundColor = UIColor.white
        footerImage.layer.cornerRadius = 8.0
    }
    
}
