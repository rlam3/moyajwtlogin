//
//  UserAuthenticationTokens.swift
//

import Mapper

struct UserAuthenticationTokens: Mappable{
    
    let access_token: String
    let refresh_token: String
    
    init(map: Mapper) throws {
        try access_token = map.from("access_token")
        try refresh_token = map.from("refresh_token")
    }
    
}


struct RefrehedAccessToken: Mappable{
    
    let new_access_token: String
    
    init(map: Mapper) throws {
        try new_access_token = map.from("access_token")
    }
    
//    func save() -> Void {
//        AuthManager.shared.accessToken = new_access_token
//    }
    
}
