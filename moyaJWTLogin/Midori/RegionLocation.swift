//
//  RegionLocation.swift
//  Midori
//
//  Created by Raymond Lam on 12/22/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import Mapper

struct OrganizationRegionLocation: Mappable {

    let address_line_1: String
    let address_line_2: String
    let city: String
    let province_state: String
    let postal_code: String
    let country_name: String

    func fullAddress() -> String{
        
        let elements = [
            self.address_line_1,
            self.address_line_2,
            self.city,
            self.province_state,
            self.postal_code,
            self.country_name,
            
        ]
        var cleanedAddress:String = ""

        for el in elements{
            cleanedAddress.append(" ")
            cleanedAddress.append(el)
        }

        
        return cleanedAddress
    }
    
    init(map: Mapper) throws {
        try address_line_1 = map.from("address_line_1")
        try address_line_2 = map.from("address_line_2")
        try province_state = map.from("province_state")
        try city = map.from("city")
        try postal_code = map.from("postal_code")
        try country_name = map.from("country_name")
    }
    
}
