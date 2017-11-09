//
//  SearchRxModel.swift
//  Midori
//
//  Created by Raymond Lam on 12/21/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Mapper

struct SearchRxModel{
    
    let provider: Networking
    let latestSearchTerm: Observable<String>
    
    func findOrganization() -> Observable<[SearchResultMap]> {
        return latestSearchTerm
            .observeOn(MainScheduler.instance)
            .flatMap{ searchTerm -> Observable<[SearchResultMap]> in
                return self.provider.request(.searchForTerm(term: searchTerm))
                    .debug()
                    .filterSuccessfulStatusCodes()
                    .map(to: [SearchResultMap].self, keyPath: "data")
            }
    }
    
}
