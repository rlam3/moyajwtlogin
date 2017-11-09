//
//  UserProfile.swift
//

import Foundation
import Moya_ModelMapper
import Mapper


struct EcoFootprint: Mappable{
    let energy: Double
    let greenhouse_gas: Double
    let trees: Double
    let water: Double
    
    init(map: Mapper) throws {
        try energy = map.from("energy")
        try greenhouse_gas = map.from("greenhouse_gas")
        try trees = map.from("trees")
        try water = map.from("water")
    }
}




typealias UserEcoFootprint = EcoFootprint

struct UserProfile: Mappable{
    
    let user_full_name: String
//    let eco_footprint: UserEcoFootprint
    
    init(map: Mapper) throws {
    
        try user_full_name = map.from("user_full_name")
//        try eco_footprint = map.from("eco_footprint")
        
    }
    
}
