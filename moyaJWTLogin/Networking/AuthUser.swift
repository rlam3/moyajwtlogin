//
//  AuthUser.swift
//  moyaJWTLogin
//

import Foundation
import Cely
import JWTDecode
import RxSwift

//struct SmartAccessToken: Expirable {
//
//    let expiresAt: Date
//    var expirationMarginInterval: TimeInterval { return 30 }
//    
//    let tokenString: String = AuthUser.get(.access_token) as! String
//    
//}

struct SmartAccessToken: Expirable {
    
    let jwt: JWT = try! decode(jwt: AuthUser.get(.access_token) as! String)
    
    var expiresAt: Date {
        get{
            let jwt = try! decode(jwt: AuthUser.get(.access_token) as! String)
            return jwt.expiresAt!
        }
    }
    
    var expirationMarginInterval: TimeInterval { return 30 }
    
}


struct AuthUser: CelyUser {
    
    enum Property: CelyProperty {
        
        case username = "username"
        case email = "email"
        case access_token = "access_token"
        case refresh_token = "refresh_token"
            
        func securely() -> Bool {
            switch self {
            case .access_token, .refresh_token:
                return true
            default:
                return false
            }
        }
        
        func persisted() -> Bool {
            switch self {
            case .access_token, .refresh_token:
                return true
            default:
                return false
            }
        }
        
        func save(_ value: Any) {
            Cely.save(value, forKey: rawValue, securely: securely(), persisted: persisted())
        }
        
        func get() -> Any? {
            return Cely.get(key: rawValue)
        }
    }
}

// MARK: - Save/Get User Properties

extension AuthUser {
    
    static func save(_ value: Any, as property: Property) {
        property.save(value)
    }
    
    static func save(_ data: [Property : Any]) {
        data.forEach { property, value in
            property.save(value)
        }
    }
    
    static func get(_ property: Property) -> Any? {
        return property.get()
    }
    
}

extension AuthUser {

    static func isAccessTokenExpired(_ value: String, property: Property) -> Bool {
        let jwt = try? decode(jwt: AuthUser.get(.access_token) as! String)
        return jwt!.expired
    }
    
}

