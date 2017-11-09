//
//  UserSettings.swift
//  Midori
//
//  Created by Raymond Lam on 12/15/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation

extension UserDefaults{
    
    enum UserDefaultKeys:String{
        case isLoggedIn
        case userAccount
    }
    
    
    // UserDeraults isLoggedIn
    
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func setIsLoggedIn(value: Bool){
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    
    // UserDefaults userAccount 
    
    func userAccount() -> String{
        return string(forKey: UserDefaultKeys.userAccount.rawValue)!
    }
    
    func setUserAccount(value: String){
        set(value, forKey: UserDefaultKeys.userAccount.rawValue)
        synchronize()
    }
    
}
