//
//  UserProfileViewControllerEcoFootprint.swift
//  Midori
//
//  Created by Raymond Lam on 12/24/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit
import FlatUIColors

class UserProfileViewControllerEcoFootprint: UIView{
    
    
    // MARK: Outlets
    @IBOutlet weak var waterCount: UILabel!
    @IBOutlet weak var carbonCount: UILabel!
    @IBOutlet weak var energyCount: UILabel!
    @IBOutlet weak var treeCount: UILabel!
    @IBOutlet weak var myConservationEffortsTitle: UILabel!
    
    
    @IBOutlet weak var treeIcon: UIImageView?
    @IBOutlet weak var waterIcon: UIImageView?
    @IBOutlet weak var electricIcon: UIImageView?
    @IBOutlet weak var houseIcon: UIImageView?
    
    
    // var
    
    var userProfile:UserProfile?{
        didSet{
            configureTitle()
            configureImageIcons()
            configure()
        }
    }
    
    /// Configure title
    func configureTitle() {
        myConservationEffortsTitle.text = NSLocalizedString("My Conservation Efforts", comment: "UserProfileVC")
    }
    
    
    /// Configure the icons next to the data
    func configureImageIcons() {
        treeIcon?.setFAIconWithName(icon: .FATree, textColor: FlatUIColors.nephritis())
        waterIcon?.setFAIconWithName(icon: .FATint, textColor: FlatUIColors.dodgerBlue())
        electricIcon?.setFAIconWithName(icon: .FABolt, textColor: FlatUIColors.sunflower())
        houseIcon?.setFAIconWithName(icon: .FAHome, textColor: FlatUIColors.midnightBlue())
    }
    
    /// MARK: Configure ecofootprint data to be shown with proper locale
    func configure() {
        
        let eco_footprint = userProfile?.eco_footprint
        
        // Apply measurement wrapper
        let waterMeasurement = Measurement(value: eco_footprint!.water, unit: UnitVolume.kiloliters)
        
        let energyMeasurement = Measurement(value: eco_footprint!.energy, unit: UnitEnergy.kilowattHours)
        
        let carbonMeasurement = Measurement(value: eco_footprint!.greenhouse_gas, unit: UnitMass.kilograms)
                
        let formatter = MeasurementFormatter.ecoFootprintFormatter
        let energyFormatter = MeasurementFormatter.ecoFootprintFormatterForEnergy
        
        // By default this is converting based on Global user setting
        
        let treeString = NSLocalizedString("trees", comment: "user profile tree counter")
        treeCount?.text = "\(eco_footprint!.trees)".appending(treeString)
        
        let waterString = NSLocalizedString("of water", comment: "user profile water stats")
        waterCount?.text = formatter.string(from: waterMeasurement).appending(waterString)
        
        let energyString = NSLocalizedString("of electricity", comment: "user profile energy")
        // Energy is always in Kwh not in Kcal
        energyCount?.text = energyFormatter.string(from: energyMeasurement).appending(energyString)
        
        let carbonString = NSLocalizedString("of carbon emissions", comment: "user profile carbon count")
        carbonCount?.text = formatter.string(from: carbonMeasurement).appending(carbonString)
        
    }
    
    
}

