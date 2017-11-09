//
//  Utility.swift
//  Midori
//
//  Created by Raymond Lam on 6/23/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func localized(_ comment:String) -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func prettifyNumbers(_ number:Float) -> String {
        
        /// prettifyNumbers
        
        var finalResultString = ""
        
        /// Logic
        /// - 1000 < x
        /// -  100 < x < 1000
        /// - x < 100
        
        if number > 1000 {
            let divided = number/1000
            finalResultString = String(format: "%.2fk", divided)
        }else if number < 1000 && number > 100{
            finalResultString = String(format: "%.1f", number)
        }else{
            finalResultString = String(format: "%.2f", number)
        }
        
        return finalResultString
    }
    
    
}


// Anything that can hold a value (strings, arrays, etc)
protocol Occupiable {
    var isEmpty: Bool { get }
    var isNotEmpty: Bool { get }
}

// Give a default implementation of isNotEmpty, so conformance only requires one implementation
extension Occupiable {
    var isNotEmpty: Bool {
        return !isEmpty
    }
}

//extension String: Occupiable { }
