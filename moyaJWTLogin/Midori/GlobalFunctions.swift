//
//  GlobalFunctions.swift
//  Midori
//
//  Created by Raymond Lam on 11/11/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import ReachabilitySwift
import RxSwift


// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternetOrStubbing() -> Observable<Bool> {
    
    let reachabilityManager = Reachability.init(hostname: "http://www.google.com")
    
    let online:Bool = (reachabilityManager?.isReachable)!
    return .just(online)

}
