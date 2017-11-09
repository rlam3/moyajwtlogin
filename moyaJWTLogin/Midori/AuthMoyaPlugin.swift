//
//  AuthMoyaPlugin.swift
//  Midori
//
//  Created by Raymond Lam on 11/3/17.
//  Copyright © 2017 Midori. All rights reserved.
//

import Foundation
import Moya

class TokenSource {
    var token: String?
    init() { }
}

protocol AuthorizedTargetType: TargetType {
    var needsAuth: Bool { get }
}

struct AuthPlugin: PluginType {
    let tokenClosure: () -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
       
        guard
            let token = tokenClosure(),
            let target = target as? AuthorizedTargetType,
            target.needsAuth
        else {
            return request
        }
        
        var request = request
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

