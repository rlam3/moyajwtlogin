//
//  Mapper+Helpers.swift
//  Midori
//
//  Created by Raymond Lam on 12/19/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Mapper

extension Transform {
    
    static func stringToInt(object: Any) throws -> Int {
        
        guard let string = object as? String else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        return Int(string)!
    }
    
    
    static func stringToURL(object: Any) throws -> URL? {
        
        guard let string = object as? String else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        // If string exists
        if string.isEmpty{
            return URL(string: "")
        }else{
            return URL(string: string)
        }
        
    }
    
    static func stringToDate(object: Any?) throws -> Any? {
        
        if object is NSNull{
            NSLog("NS NULL RETURNS NILL")
            return nil
        }
        
        guard let string = object as? String else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        // Create formatter of time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        
        if let date = dateFormatter.date(from: string) {
            return date
        }
        
        throw MapperError.convertibleError(value: object, type: String.self)
        
    }
    

}
