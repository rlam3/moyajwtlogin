//
//  CSRFToken.swift
//  Midori
//
//  Created by Raymond Lam on 10/28/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Mapper

struct CSRFToken: Mappable{
    
    let csrf_token: String
    
    init(map: Mapper) throws {
        try csrf_token = map.from("csrf_token")
    }
    
    func save() -> Void {
        AuthManager.shared.csrf_token = csrf_token
    }
    
}
