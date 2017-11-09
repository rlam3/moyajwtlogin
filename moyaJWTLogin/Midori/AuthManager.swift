//
//  AuthManager.swift
//  Midori
//
//  Created by Raymond Lam on 11/8/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import JWTDecode
// We use Keychain / Locksmith because NSUserDefaults is not safe enough
import Locksmith
import Moya
import RxSwift


struct OAuthToken: Expirable{
    let token: String
    let refreshToken: String
    
    let expiresAt: Date
    var expirationMarginInterval: TimeInterval { return 30 }
    
}


class AuthManager{
    
    enum DefaultKeys: String{
        
        case service = "io.Midori"
        
        case Email = "Email"
        case Password = "Password"
        
        case CSRFToken = "csrf_token"
        
        case AccessToken = "access_token"
        case RefreshToken = "refresh_token"
        
        case DefaultLanguage = "default_language"
        case UserSetLanguage = "user_set_language"
        
        
    }
    
    static let shared = AuthManager()
    
    // accountFromUserDefaults
    //let accountFromUserDefault:String = UserDefaults.standard.userAccount()
    
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
    
    
    var userSetLanguage: String?{
        get{
            // Get Email from Locksmith
            if let _userSetLanguage:String = getElement(DefaultKeys.UserSetLanguage.rawValue) as? String{
                return _userSetLanguage
            }
            return nil
        }
        set(newUserSetLanguage){
            setElement(DefaultKeys.UserSetLanguage.rawValue, newElement: newUserSetLanguage! as AnyObject)
        }
    }
    
    
    // MARK: - Properties
    
    var email: String?{
        get{
            // Get Email from Locksmith
            if let _email:String = getElement(DefaultKeys.Email.rawValue) as? String{
                return _email
            }
            return nil
        }
        set(newEmail){
            setElement(DefaultKeys.Email.rawValue, newElement: newEmail! as AnyObject)
        }
    }
    
    var password: String?{
        get{
            // Get password from Locksmith
            if let _password:String = getElement(DefaultKeys.Password.rawValue) as? String{
                return _password
            }
            return nil
        }
        set(newPassword){
            //Set password to Locksmith
            setElement(DefaultKeys.Password.rawValue, newElement: newPassword! as AnyObject)
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
    
//    var accessTokenJWT:JWT {
//        get{
//            
//            do{
//                let jwt = try JWTDecode.decode(jwt: accessToken!)
//                return jwt
//            }catch let error as NSError{
//                NSLog("\(error.localizedDescription)")
//                return JWTDecode.DecodeError as! JWT
//            }
//            
//        }
//    }
    
    var accessTokenWithBearer:String? {
        get {
            if let key = accessToken {
                return "Bearer \(key)"
            }
            else { return nil }
        }
    }

    var refreshTokenWithBearer:String? {
        get {
            if let key = refreshToken {
                return "Bearer \(key)"
            }
            else { return nil }
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
    
    var hasAccessToken: Bool{
        if let _ = self.accessToken{
            return true
        }
        return false
    }
    
    var hasRefreshToken: Bool{
        if let _ = self.refreshToken{
            return true
        }
        return false
    }
    
    
}


// MARK: CSRF TOKEN MANAGER
extension AuthManager{
    // Managing of csrf token....
    // We need this because requet closure is too croweded
    
    // FIXME: Cannot add provider here
    //    var provider:RxMoyaProvider<MidoriMoyaAPI>
    
    
    var csrf_token: String?{
        get{
            if let _csrfToken:String = getElement(DefaultKeys.CSRFToken.rawValue) as? String{
                return _csrfToken
            }
            return nil
        }
        set(newCSRFToken){
            setElement(DefaultKeys.CSRFToken.rawValue, newElement: newCSRFToken as AnyObject)
        }
    }
    
    ///
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


extension AuthManager{
    
    enum UserStateType {
        case loggedIn
        case loggedOut
        case expiredToken
    }
    
//    enum AccessTokenStateType {
//        case FoundNoAccessToken
//        case GoodToken
//        case ExpiredToken
//    }
//    
//    var accessTokenState:AccessTokenStateType{
//        get {
//            
//            var state:AccessTokenStateType!
//            
//            if hasAccessToken{
//                if expiredAccessToken{
//                    state = AccessTokenStateType.ExpiredToken
//                }else{
//                    state = AccessTokenStateType.GoodToken
//                }
//            }else{
//                state = AccessTokenStateType.FoundNoAccessToken
//            }
//            
//            return state
//        }
//    }
    
    
    var currentUserState:UserStateType{
        get{
            
            var state:UserStateType!
            
            if hasAccessToken{
                if expiredAccessToken{
                    state = UserStateType.expiredToken
                }else{
                    state = UserStateType.loggedIn
                }
            }else{
                state = UserStateType.loggedOut
            }
            
            return state
        }
    }
    
//    
//    var currentUserState:UserStateType{
//        get{
//            
//            var state:UserStateType!
//
//            if UserDefaults.standard.isLoggedIn(){
//                state = UserStateType.loggedIn
//            }else{
//                state = UserStateType.loggedOut
//            }
//            
//            return state
//            
//        }
//    }
//    
    
    
    
    
}




/// MARK: PRIVATE

fileprivate extension Date {
    var isInPast: Bool {
        let now = Date()
        return self.compare(now) == ComparisonResult.orderedAscending
    }
}


