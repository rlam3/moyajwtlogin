//
//  GradientLayers.swift
//  Midori
//
//  Created by Raymond Lam on 3/29/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit

extension CAGradientLayer {
    
    func turquoiseColor() -> CAGradientLayer {
        let topColor = UIColor(red: (15/255.0), green: (118/255.0), blue: (128/255.0), alpha: 1)
        let bottomColor = UIColor(red: (84/255.0), green: (187/255.0), blue: (187/255.0), alpha: 1)
        
        let gradientColors: Array <AnyObject> = [topColor.cgColor, bottomColor.cgColor]
//        let gradientLocations: Array <AnyObject> = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
//        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
    
    
    
}
