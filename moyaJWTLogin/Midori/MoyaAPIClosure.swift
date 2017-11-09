//
//  MidoriProvider2.swift
//  Midori
//
//  Created by Raymond Lam on 10/28/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import Moya
import Locksmith
import JWTDecode
import RxSwift

class MoyaAPIClosures{
    
    ///
    static let endpointClosure = { (target: MidoriMoyaAPI) -> Endpoint<MidoriMoyaAPI> in
        
        print("Endpoint Closure Config")

        var defaultEndpoint:Endpoint<MidoriMoyaAPI> = MoyaProvider.defaultEndpointMapping(for: target)
        
        switch target{
        case .getCSRF:
            return defaultEndpoint
        case .getUserProfile, .refreshAccessToken:
            return defaultEndpoint
        default:
            return defaultEndpoint
        }
    }
    
}
