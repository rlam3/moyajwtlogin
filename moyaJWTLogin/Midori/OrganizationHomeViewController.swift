//
//  OrganizationHomeViewController.swift
//  Midori
//
//  Created by Raymond Lam on 11/7/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit
import Moya
import RxSwift
import Locksmith
import Font_Awesome_Swift
import FlatUIColors

class OrganizationHomeViewController: UIViewController{
    
    
    @IBOutlet weak var organizationHeader: OrganizationHomeViewControllerHeader!
    @IBOutlet weak var organizationInfoStats: OrganizationHomeViewControllerOrgStats!
    @IBOutlet weak var organizationEcoFootprintSection: OrganizationHomeViewControllerEcoFootprint!
    @IBOutlet weak var organizationFooterNav: OrganizationHomeViewControllerNav!
    
    // From previous view
    var organization: SearchResultMap?
    
    // Get Rx object from this view
    var organizationFromRx: OrganizationJSONMap?
    
    var provider: Networking!
    let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        setupFooterNav()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Get Org info again and assign it back to organization.

    }
    
    
    func setupRx() {
        provider = Networking.newDefaultNetworking()
        
        provider.request(.getOrganization(organizationUUID: (organization?.uuid)!))
//            .debug("SETUP RX FOR GET ORGANIZATION::::::::::::;")
            .filterSuccessfulStatusCodes()
            .map(to: OrganizationJSONMap.self, keyPath:"organization")
            .subscribe{ (event) in
                
                switch event{
                case .next(let object):
                    
                    self.organizationFromRx = object
                    self.configureSectionViews()
                    
                case .error(let error):
                    // Log issue
                    print("::::::::::::::::::::::::::::::::: mapping error??? \(error.localizedDescription)")
                default:break
                }
                
            }.disposed(by: disposeBag)
        
    }
    
    
    /// MARK: Configure Section Views
    func configureSectionViews(){
        
        organizationHeader.organization = organizationFromRx
        organizationInfoStats.organization = organizationFromRx
        organizationEcoFootprintSection.eco_footprint = organizationFromRx?.eco_footprint

    }
    
    
    func setupFooterNav() {
        
        let navTextColor:UIColor = FlatUIColors.midnightBlue()
        let navButtonBackgroundColor:UIColor = FlatUIColors.clouds()
        
        let ourLocationButtonText = NSLocalizedString("Our Locations", comment: "OrganizationHomeVC")
        
        organizationFooterNav.locationButton.setFAText(prefixText: "", icon: .FAMapMarker, postfixText: ourLocationButtonText, size: 40, forState: .normal, iconSize: 50)
        organizationFooterNav.locationButton.setFATitleColor(color:navTextColor, forState: .normal)
        organizationFooterNav.locationButton.titleLabel?.textAlignment = .center
        organizationFooterNav.locationButton.backgroundColor = navButtonBackgroundColor
        
        let ourPublicationButtonText = NSLocalizedString("Our Publications", comment: "OrganizationHomeVC")
        
        organizationFooterNav.flyerButton.setFAText(prefixText: "", icon: FAType.FALeanpub, postfixText: ourPublicationButtonText, size: 40, forState: .normal, iconSize: 50)
        organizationFooterNav.flyerButton.setFATitleColor(color:navTextColor, forState: .normal)
        organizationFooterNav.flyerButton.titleLabel?.textAlignment = .center
        organizationFooterNav.flyerButton.backgroundColor = navButtonBackgroundColor
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "showRegionModal") {
            // pass the data
            let nvc = segue.destination as! UINavigationController
            let dvc = nvc.topViewController as! OrganizationRegionTableViewController
            dvc.organizationUUID = organization?.uuid
        }else if(segue.identifier == "showOrganizationRegionSelector"){
            
            print("Selected region to view flyer / location")
            
            let dvc = segue.destination as! OrganizationRegionSelectorCollectionViewController
            
            dvc.organizationUUID = organization?.uuid
            
            switch (sender! as AnyObject).tag {
            case 0:
                dvc.selected = "Location"
            case 1:
                dvc.selected = "Publication"
            default:
                break
            }
            

        }
        
    }
    
    
    @IBAction func unwindFromModal(_ segue: UIStoryboardSegue) {
        print("unwindFromModal")
    }
    
}
