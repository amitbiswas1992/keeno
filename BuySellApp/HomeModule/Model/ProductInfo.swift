//
//  ProductMapper.swift
//  BuySellApp
//
//  Created by Sanzid on 4/1/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import ObjectMapper

class ProductInfo: Mappable {
    
    @objc dynamic var id : Int = 0

    
    required convenience init?(map: Map) {
        
        
        self.init()
        
        
    }
    
    //  Mappable
    func mapping(map: Map) {
        id <- map["id"]
    }
}


