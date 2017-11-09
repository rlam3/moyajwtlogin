//
//  OrganizationHomeViewControllerHeader.swift
//  Midori
//
//  Created by Raymond Lam on 11/7/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import FlatUIColors


class OrganizationHomeViewControllerHeader: UIView{
    
    @IBOutlet fileprivate weak var organizationName: UILabel?
    @IBOutlet fileprivate weak var organizationWebsite: UILabel?
    @IBOutlet fileprivate weak var organizationLogo: UIImageView?
    @IBOutlet fileprivate weak var subscribeButton: UIButton?

//    var organizationOld: SearchResultMap?{
//        didSet{
//            configure()
//        }
//    }
//    
    var organization: OrganizationJSONMap?{
        didSet{
            configure()
            print("CONFIGURE HEADER!!!")
        }
    }

    
    func configure(){

        self.backgroundColor = FlatUIColors.clouds()
        
        organizationName?.text = organization?.display_name
        organizationWebsite?.text = organization?.website
        
        organizationName?.textColor = FlatUIColors.midnightBlue()
        organizationWebsite?.textColor = FlatUIColors.midnightBlue()
        
        subscribeButton?.backgroundColor = FlatUIColors.midnightBlue()
        
        
        if let url:URL = organization?.logo_url{
        
            let placeholderImage = UIImage(icon: .FABuilding, size: CGSize(width:50 , height:50), textColor: FlatUIColors.midnightBlue(), backgroundColor: .white)

            organizationLogo?.kf.setImage(
                with: url,
                placeholder: placeholderImage,
                options: [.transition(.fade(0.2))],
                progressBlock: nil,
                completionHandler: { (image, error, _, _) in
                    
                    if error != nil {
                        NSLog((error?.localizedDescription)!)
                    }
                    
                    self.organizationLogo?.image = image
                    
            })
            
        }else{
            
            // NO URL
            print("something wrong with url !!!!!")
            
            organizationLogo?.setFAIconWithName(icon: .FABuilding, textColor: FlatUIColors.midnightBlue(), backgroundColor: .white, size: CGSize(width:128, height:128))
        }
        
        // Creates round circle around image
        organizationLogo?.image = imageByRoundingCornersOfImage((organizationLogo?.image)!)
        
    }
    
        
    func imageByRoundingCornersOfImage(_ image:UIImage) -> UIImage{
        organizationLogo?.layer.cornerRadius = organizationLogo!.frame.size.width / 2;
        organizationLogo?.clipsToBounds = true
        organizationLogo?.layer.borderWidth = 3.0
        organizationLogo?.layer.borderColor = FlatUIColors.midnightBlue().cgColor
        organizationLogo?.layer.backgroundColor = UIColor.white.cgColor
        return (organizationLogo?.image!)!
    }
    
    
}

fileprivate extension UnitEnergy{
    static var lightBulbsCFL: UnitEnergy{
        // 1 CFL = 15w/hr
        return UnitEnergy(symbol: "CFL",
                          converter: UnitConverterLinear(coefficient: 15))
    }
}

