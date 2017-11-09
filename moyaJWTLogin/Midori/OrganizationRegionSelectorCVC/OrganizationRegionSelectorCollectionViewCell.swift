//
//  OrganizationRegionSelectorCollectionViewCell.swift
//  Midori
//
//  Created by Raymond Lam on 12/22/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import FlatUIColors
import UIKit

class OrganizationRegionSelectorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var regionName: UILabel!
    @IBOutlet weak var defaultRegionPic: UIImageView!
    
    var region: OrganizationRegion?{
        didSet{
            configure()
        }
    }
    
    func configure() {
        
        self.backgroundColor = FlatUIColors.clouds()
        
        regionName.text = region?.name
        regionName.textColor = FlatUIColors.midnightBlue()
        defaultRegionPic.setFAIconWithName(icon: .FAMapMarker, textColor: FlatUIColors.midnightBlue())
    }
    
}
