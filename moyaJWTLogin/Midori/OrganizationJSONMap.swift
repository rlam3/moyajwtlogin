//
//  OrganizationJSONMap.swift
//  Midori
//
//  Created by Raymond Lam on 11/11/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import Mapper

struct OrganizationJSONMap: Mappable{

    let numberOfPublications:Int
    let numberOfSubscribers:Int

    let organization_id: Int
    let description: String
    let display_name: String
    let logo_url: URL?
    let uuid: String
    let website: String
    let eco_footprint: EcoFootprint


    init(map: Mapper) throws {

        try organization_id = map.from("id")
        try description = map.from("description")
        try display_name = map.from("display_name")
        logo_url = map.optionalFrom("logo._public_url")
        try uuid = map.from("name")
        try website = map.from("website")

        try numberOfSubscribers = map.from("number_of_unique_subscribers")
        try numberOfPublications = map.from("number_of_publications")

        try eco_footprint = map.from("eco_footprint")

    }

}


struct EcoFootprint: Mappable{
    let energy: Double
    let greenhouse_gas: Double
    let trees: Double
    let water: Double

    init(map: Mapper) throws {
      try energy = map.from("energy")
      try greenhouse_gas = map.from("greenhouse_gas")
      try trees = map.from("trees")
      try water = map.from("water")
    }
}




