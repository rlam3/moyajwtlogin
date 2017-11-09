//
//  RegionLocationTableViewCell.swift
//  Midori
//
//  Created by Raymond Lam on 12/24/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import UIKit
import FlatUIColors
import Font_Awesome_Swift

class RegionLocationTableViewCell: UITableViewCell {

    // MARK: Outlets
    
    @IBOutlet weak var addressPin: UIImageView!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var postalCountry: UILabel!
    
    
    // Set location via tableviewcontroller
    
    var location: OrganizationRegionLocation?{
        didSet{
            configure()
        }
    }
    
    
    
    func configure() {
        
        // Set Address etc
        
        addressPin.setFAIconWithName(icon: .FAMapPin, textColor: FlatUIColors.midnightBlue())
        
        
        streetAddress.text = location!.address_line_1
        postalCountry.text = String("\(location!.city), \(location!.province_state) \(location!.postal_code)")
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }


    
}
