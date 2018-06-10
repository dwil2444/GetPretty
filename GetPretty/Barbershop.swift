//
//  Barbershop.swift
//  GetPretty
//
//  Created by CbUser1 on 6/8/18.
//  Copyright © 2018 zygium. All rights reserved.
//

import Foundation

struct BarberShop {
    let name: String
    let location: ( addressLocality: String, addressRegion: String, postalCode: String )
    let phone: String
}

extension BarberShop {
    
    init?(json: [String: Any]){
        
        guard let name = json["name"] as? String,
            let phone = json["phone"] as? String,
            let locationJSON = json["address"] as? [String: String],
            let locality = locationJSON["addressLocality"],
            let region = locationJSON["addressRegion"],
            let postal = locationJSON["postalCode"]
            else{
                return nil
        }
        
        self.name = name
        self.location = (locality, region, postal)
        self.phone = phone
        
    }
    
    
    
    
}
