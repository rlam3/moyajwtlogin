//
//  OrganizationHomeViewControllerEcoFootprint.swift
//  Midori
//
//  Created by Raymond Lam on 11/14/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit
//import Scale

class OrganizationHomeViewControllerEcoFootprint: UIView{
    

    // MARK: IBOutlets
    
    @IBOutlet weak var treeIcon: UIImageView?
    @IBOutlet weak var waterIcon: UIImageView?
    @IBOutlet weak var boltIcon: UIImageView?
    @IBOutlet weak var houseIcon: UIImageView?

    @IBOutlet weak var treeCount: UILabel?
    @IBOutlet weak var waterCount: UILabel?
    @IBOutlet weak var electricCount: UILabel?
    @IBOutlet weak var carbonCount: UILabel?
    

    var eco_footprint: EcoFootprint?{
        didSet{
            configure()
            print("CONFIGURE Ecofootprint!!!")
        }
    }
    
    func configure(){
        
        configureStats()
        configureColors()
    }
    

    func configureColors() -> Void {
        
        let x:Array<UIImageView> = [treeIcon!,waterIcon!,boltIcon!,houseIcon!]
        
        for item in x{
            item.tintImageColor(UIColor.white)
        }
    
    }
    
    func configureStats(){
        
        // Default locale system of measurements
        _ = Locale.current.usesMetricSystem
        
        // We can override from settings
//        let userDefaultSettingIsMetricSystem = UserDefaults.standard.isMetricSystem
        

        // Apply measurement wrapper
        let waterMeasurement = Measurement(value: eco_footprint!.water, unit: UnitVolume.kiloliters)
        
        let energyMeasurement = Measurement(value: eco_footprint!.energy, unit: UnitEnergy.kilowattHours)
        
        let carbonMeasurement = Measurement(value: eco_footprint!.greenhouse_gas, unit: UnitMass.kilograms)

        let formatter = MeasurementFormatter.ecoFootprintFormatter
        let energyFormatter = MeasurementFormatter.ecoFootprintFormatterForEnergy
        
        // By default this is converting based on Global user setting
        
        let treeString = NSLocalizedString("trees", comment: "OrganizationHomeVC ecofootprint trees")
        treeCount?.text = "\(eco_footprint!.trees)".appending(treeString) 
        
        waterCount?.text = formatter.string(from: waterMeasurement).appending(NSLocalizedString("of water", comment: "OrganizationHomeVC ecofootprint water"))
        
        // Energy is always in Kwh not in Kcal
        electricCount?.text = energyFormatter.string(from: energyMeasurement).appending(NSLocalizedString("of electricity", comment: "OrganizationHomeVC ecofootprint energy"))
        
        carbonCount?.text = formatter.string(from: carbonMeasurement).appending(NSLocalizedString("of carbon emissions", comment: "OrganizationHomeVC ecofootprint carbon emission"))
        
    }
    
}


private extension UIImageView {
    func tintImageColor(_ color : UIColor) {
        self.image = self.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.tintColor = color
    }
}
