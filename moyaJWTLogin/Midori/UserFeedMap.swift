//
//  UserFeedJSONMap.swift
//  Midori
//
//  Created by Raymond Lam on 12/17/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Mapper

// OK
struct PublicationFeedMap: Mappable{

    let description: String
    let expiry_date: Any?
    let id: Int
    let isReleased: Bool
    let organization_display_name: String
    let organization_uuid: String
    let organizationid: Int
    let pub_date: String
    
    let title: String

    let pulication_files: [PublicationPage]!
    let top_cover: PublicationTopCoverMap
    let target_region: PublicationTargetRegionMap

    init(map: Mapper) throws {

      try description = map.from("description")
      expiry_date = map.optionalFrom("expiry_date", transformation: Transform.stringToDate)
      try id = map.from("id")
      try isReleased = map.from("isReleased")
      try organization_display_name = map.from("organization_display_name")
      try organization_uuid = map.from("organization_uuid")
      try organizationid = map.from("organizationid")
      try pub_date = map.from("pub_date")

      try title = map.from("title")
        
      try pulication_files = map.from("publication_files")
      try top_cover = map.from("top_cover")
      try target_region = map.from("target_region")
        
    }
    
    var organizationRegionString: String {
        return String(format:"%@ - %@", self.organization_display_name, self.target_region.name)
    }
    
    func heightForCaption(_ font: UIFont, width: CGFloat) -> CGFloat {
        /// FIXME: Format with NSDateFormatter
        let expiryDateStr = "\(String(describing: expiry_date))"
        let caption = "\(title)\n\(expiryDateStr)\n\(organizationRegionString)"
        
        let rect = (caption as NSString).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font: font], context: nil)
        return ceil(rect.height)
    }
    
}



struct PublicationTargetRegionMap: Mappable{
    
    let id: Int
    let name: String
    
    init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
    }
    
}

struct PublicationTopCoverMap: Mappable{
    
    let height: Int
    let width: Int
    let size: CGSize
    let url: URL!
    
    init(map: Mapper) throws {
        try height = map.from("height")
        try width = map.from("width")
        try url = map.from("url", transformation: Transform.stringToURL)
        
        // Get CGSize
        self.size = CGSize(width: width, height: height)
    }
    

}

struct PublicationPage: Mappable{
    
    let urlString: String
    let url: URL
    
    init(map: Mapper) throws {
        try urlString = map.from("full_cdn_path")
        try url = map.from("full_cdn_path",transformation: Transform.stringToURL)!
    }
    
}


struct UserPublicationFeedMap: Mappable{

    let publications: [PublicationFeedMap]
    let publicationPagination: PublicationPaginationMap

    init(map: Mapper) throws {
      try publications = map.from("data")
      try publicationPagination = map.from("page")
    }

}

struct PublicationPaginationMap: Mappable{

    let  current: String // /api/v1.0/user/feed/1?limit=10",
    //let  next: String // /api/v1.0/user/feed/2?limit=10",
    // let  prev: String
    // let  prev_num: Int
    let  next_num: Int
    let  total: Int
    let  total_pages: Int
    let  total_per_page: Int

    init(map: Mapper) throws {
        try current = map.from("current") // /api/v1.0/user/feed/1?limit=10",
        //next = map.optionalFrom("next")! // /api/v1.0/user/feed/2?limit=10",
        next_num = map.optionalFrom("next_num")!
        try total = map.from("total")
        try total_pages = map.from("total_pages")
        try total_per_page = map.from("total_per_page")
    }

}
