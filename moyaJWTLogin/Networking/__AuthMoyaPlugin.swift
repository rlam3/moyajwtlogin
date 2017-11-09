//
//  AuthMoyaPlugin.swift
//

import Foundation
import Moya

protocol AuthorizedTargetType: TargetType {
    var requiresAuthentication: Bool { get }
}

struct AuthPlugin: PluginType {
    let tokenClosure: () -> String?
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        
        guard
            let token = tokenClosure(),
            let target = target as? AuthorizedTargetType,
            target.requiresAuthentication
        else {
            return request
        }
        
        var request = request
        request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        return request
    }
}

