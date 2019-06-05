//
//  ProductMapper.swift
//  BuySellApp
//
//  Created by Sanzid on 4/1/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import ObjectMapper

class Offer: Mappable {
    
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var price : Int = 0
    @objc dynamic var created_at : String = ""
    @objc dynamic var updated_at : String = ""
    @objc dynamic var duration : Int = 0
    
    
    required convenience init?(map: Map) {
        
        
        self.init()
        
        
    }
    
    //  Mappable
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        price <- map["price"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        duration <- map["duration"]
        
    }
}


