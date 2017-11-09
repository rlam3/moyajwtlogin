//
//  UserAuthenticationTokens.swift
//  Midori
//
//  Created by Raymond Lam on 12/2/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Mapper

struct UserAuthenticationTokens: Mappable{
    
    let access_token: String
    let refresh_token: String
    
    init(map: Mapper) throws {
        try access_token = map.from("access_token")
        try refresh_token = map.from("refresh_token")
    }
    
    func save() -> Void {
        AuthManager.shared.accessToken = access_token
        AuthManager.shared.refreshToken = refresh_token
    }
    
}


struct RefrehedAccessToken: Mappable{
    
    let new_access_token: String
    
    init(map: Mapper) throws {
        try new_access_token = map.from("access_token")
    }
    
    func save() -> Void {
        AuthManager.shared.accessToken = new_access_token
    }
    
}
