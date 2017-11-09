//
//  OrganizationRegionSubscriptionResponse.swift
//  Midori
//
//  Created by Raymond Lam on 10/26/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import Mapper

// FIXME: May need to update name of struct
struct OrganizationRegionSubscriptionResponseResults: Mappable{
    
    let responses: [OrganizationRegionSubscriptionResponse]?
    
    init(map: Mapper) throws {
        try responses = map.from("data")
    }
    
}

// FIXME: May need to update name of struct
struct OrganizationRegionSubscriptionResponse: Mappable{

    let id: Int?
    let name: String?
    let isSubscribed: Bool?
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try isSubscribed = map.from("is_current_user_subscribed")
    }
}


// This is okay
struct OrganizationRegion:Mappable{
    
    let id: Int?
    let name: String?
    let isSubscribed: Bool?
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try isSubscribed = map.from("is_current_user_subscribed")
    }
    
}
