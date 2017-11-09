//
//  UserProfile.swift
//  Midori
//
//  Created by Raymond Lam on 12/24/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import Mapper

typealias UserEcoFootprint = EcoFootprint

struct UserProfile: Mappable{
    
    let user_full_name: String
    let eco_footprint: UserEcoFootprint
    
    init(map: Mapper) throws {
    
        try user_full_name = map.from("user_full_name")
        try eco_footprint = map.from("eco_footprint")
        
    }
    
}
