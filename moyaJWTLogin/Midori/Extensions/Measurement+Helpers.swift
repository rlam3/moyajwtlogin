//
//  Measurement+Helpers.swift
//  Midori
//
//  Created by Raymond Lam on 12/28/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation


extension UnitVolume {
    
    static var bottles: UnitVolume {
        // 1 bottle = 500mL
        // 1 bottle = 0.5L
        return UnitVolume(symbol: "bottles of water",
                          converter: UnitConverterLinear(coefficient: 0.5))
    }
    
    static var olympicSwimmingPools: UnitVolume{
        // 1 olymic size swimming pool = 2,500,000 litres
        return UnitVolume(symbol: "olympic size swimming pool", converter: UnitConverterLinear(coefficient:2500000))
    }
    
}


extension MeasurementFormatter{
    static var ecoFootprintFormatter: MeasurementFormatter {
        
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter.alwaysShowsDecimalSeparator = true
        formatter.numberFormatter.usesGroupingSeparator = true
        
        return formatter
    }
    
    static var ecoFootprintFormatterForEnergy: MeasurementFormatter {
        
        let formatter = MeasurementFormatter()
        formatter.numberFormatter.maximumFractionDigits = 2
        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.alwaysShowsDecimalSeparator = true
        formatter.numberFormatter.usesGroupingSeparator = true
        
        return formatter
    }
    
}

