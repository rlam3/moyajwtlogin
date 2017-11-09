//
//  OrganizationHomeViewControllerInfo.swift
//  Midori
//
//  Created by Raymond Lam on 11/7/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit
import Moya
import RxSwift

class OrganizationHomeViewControllerOrgStats: UIView{

    @IBOutlet weak var subscriberCount: UILabel?
    @IBOutlet weak var publicationCount: UILabel?
//    @IBOutlet weak var EventCount: UILabel? 
    
    
    // FIXME: need to add IBAction for button for org description?
    
    var organization: OrganizationJSONMap?{
        didSet{
            configure()
            print("CONFIGURE OrgStats!!!")
        }
    }
    
    

    
    func configure() {
        
        subscriberCount?.text = String(organization!.numberOfSubscribers)
        publicationCount?.text = String(organization!.numberOfPublications)
//
        // FIXME:
        // Add events later
        
    }
    
    
}
