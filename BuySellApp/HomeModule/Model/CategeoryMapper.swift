//
//  CategeoryMapper.swift
//  BuySellApp
//
//  Created by Sanzid on 3/26/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import Foundation
import ObjectMapper

class CategeoryMapper : Mappable {
    
    
    @objc dynamic var id : Int = 0
    @objc dynamic var name : String = ""
    @objc dynamic var created_at : String = ""
    @objc dynamic var updated_at : String = ""
    @objc dynamic var icon_url: String = ""
 
    
    required convenience init?(map: Map) {
        
        
        self.init()
    
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        icon_url <- map["icon_url"]
        
    }
}
