//
//  SearchForTermMap.swift
//  Midori
//
//  Created by Raymond Lam on 12/15/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Mapper

struct SearchForTermMap: Mappable{

    let total: Int
    let search_data: [SearchResultMap]

    init(map: Mapper) throws {

        search_data = map.optionalFrom("data") ?? []
        try total = map.from("total")

    }
}


struct SearchResultMap:Mappable{

    // enum for nested data from elastic
    enum SearchResultSourceValue: String{
        case description = "_source.description"
        case display_name = "_source.display_name"
        case logo_url = "_source.logo_with_cdn_url_thumbnail"
        case uuid = "_source.uuid"
        case website = "_source.website"
    }

    let type: String
    let organization_id: Int
    let description: String
    let display_name: String
    let logo_url: URL?
    let uuid: String
    let website: String
    
    
    init(map: Mapper) throws {
        try type = map.from("_type")
        self.organization_id = try map.from("_id", transformation: Transform.stringToInt)
        try description = map.from(SearchResultSourceValue.description.rawValue)
        try display_name = map.from(SearchResultSourceValue.display_name.rawValue)
        logo_url = map.optionalFrom(SearchResultSourceValue.logo_url.rawValue, transformation: Transform.stringToURL)
        try uuid = map.from(SearchResultSourceValue.uuid.rawValue)
        try website = map.from(SearchResultSourceValue.website.rawValue)
    }

}

