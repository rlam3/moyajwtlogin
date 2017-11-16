//
//  AuthManager.swift
//  moyaJWTLogin
//
//

import Foundation
import Locksmith
import JWTDecode

//struct OAuthToken: Expirable{
//    let token: String
//    let refreshToken: String
//
//    let expiresAt: Date
//    var expirationMarginInterval: TimeInterval { return 30 }
//
//    static let shared = OAuthToken(token: <#String#>)
//
//}

class AuthManager{
    
    enum DefaultKeys: String{
        
        case service = "JWTMoya"
        
        case AccessToken = "access_token"
        case RefreshToken = "refresh_token"
        
    }
    
    static let shared = AuthManager()

//    var expirationMarginInterval: TimeInterval { return 30 }
    
    // MARK: - Element Getter and Setters
    
    func getElement(_ element:String) -> AnyObject? {
        
        if let dict = Locksmith.loadDataForUserAccount(userAccount: DefaultKeys.service.rawValue){
            // Checks if dictionary is empty first
            if dict.isEmpty{
                return nil // cannot be nil here <<<
            }
            
            if let el = dict[element] as AnyObject?{
                return el
            }else{
                return nil
            }
        }
        return nil
    }
    
    func setElement(_ element:String, newElement:AnyObject){
        
        // Assumptions:
        // Dict is set
        
        // If dict exists, update dict
        // Else create new dict with element
        
        var dict:[String:AnyObject]? = Locksmith.loadDataForUserAccount(userAccount: DefaultKeys.service.rawValue) as [String : AnyObject]?
        
        if dict != nil{
            print("Updating element: \(element)")
            
            dict![element] = newElement
            do{
                try Locksmith.updateData(data: dict!, forUserAccount: DefaultKeys.service.rawValue)
            }catch let error{
                print(error)
            }
        }else{
            do{
                print("Saving Element: \(element), :: \(newElement)")
                try Locksmith.saveData(
                    data: [element: newElement],
                    forUserAccount: DefaultKeys.service.rawValue
                )
            }catch let error{
                print("Wasn't able to save to locksmith")
                print(error.localizedDescription)
            }
        }
    }
    
    var accessToken: String? {
        get{
            // Get password from Locksmith
            if let _accessToken:String = getElement(DefaultKeys.AccessToken.rawValue) as? String{
                return _accessToken
            }
            return nil
        }
        set(newAccessToken){
            setElement(DefaultKeys.AccessToken.rawValue, newElement: newAccessToken! as AnyObject)
        }
    }
    
    var refreshToken:String? {
        get{
            
            if let _refreshToken:String = getElement(DefaultKeys.RefreshToken.rawValue) as? String{
                return _refreshToken
            }
            return nil
        }
        set(newRefreshToken){
            setElement(DefaultKeys.RefreshToken.rawValue, newElement: newRefreshToken! as AnyObject)
        }
    }
    
    var expiredRefreshToken: Bool{
        
        if ((refreshToken?.isEmpty) != nil){
            return false
        }
        do{
            let access_token = try decode(jwt: refreshToken!)
            return access_token.expired
        }catch let error as NSError{
            print(error.localizedDescription)
            return false
        }
    }
    
    var expiredAccessToken: Bool{
        
        guard accessToken != nil else{
            return true
        }
        
        do{
            let access_token = try decode(jwt: accessToken!)
            return access_token.expired
        }catch let error as NSError{
            print(error.localizedDescription)
            return false
        }
    }
    
    var isAccessTokenExpired:Bool {
        
        // If access token is not nil then return else return true because token is not found
        
        guard accessToken != nil else{
            return true
        }
        do{
            let access_token = try decode(jwt: accessToken!)
            return access_token.expired
        }catch let error as NSError{
            print(error.localizedDescription)
            return true
        }
    }
}


// MARK: CSRF TOKEN MANAGER
extension AuthManager{
    // Managing of csrf token....
    // We need this because requet closure is too croweded
    
    // FIXME: Cannot add provider here
    
    static func resetKeychain(){
        
        do{
            
            print("RESET AUTH KEYCHAIN")
            
            try Locksmith.deleteDataForUserAccount(userAccount: DefaultKeys.service.rawValue)
        }catch let error{
            print("Locksmith reset error:")
            print(error.localizedDescription)
        }
    }
    
}

/// MARK: PRIVATE

fileprivate extension Date {
    var isInPast: Bool {
        let now = Date()
        return self.compare(now) == ComparisonResult.orderedAscending
    }
}
