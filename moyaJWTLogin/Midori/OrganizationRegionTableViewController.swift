//
//  OrganizationRegionTableViewController.swift
//  Midori
//
//  Created by Raymond Lam on 10/20/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit

import Moya_ModelMapper
import Alamofire
import Moya
import RxSwift




class OrganizationRegionTableViewController: UITableViewController{
    
    var subscriptionArray:[OrganizationRegionSubscription] = []
    var rowsChanged:[Int] = []

    
    let rxProvider:Networking = Networking.newDefaultNetworking()
    
    let disposeBag = DisposeBag()
    
    var organizationUUID: String?
    
    override func viewDidLoad() {
        
        tableView.register(OrganizationRegionTableViewCell.self, forCellReuseIdentifier: "OrganizationRegionTableViewCell")
        
        self.configureNavigation()
        self.getUserSubscriptionData()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationRegionTableViewCell", for: indexPath)
        let obj = subscriptionArray[indexPath.row]
        
        cell.textLabel?.text = obj.regionName
        cell.accessoryType = obj.isSubscribed ? .checkmark : .none
    
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Update the data in array
        subscriptionArray[indexPath.row].isSubscribed = !subscriptionArray[indexPath.row].isSubscribed

        // Reload the view for row
        tableView.reloadRows(at: [indexPath], with: .fade)
        
        // Update rowsChanged
        if rowsChanged.contains(indexPath.row){
            if let indexOfDeletable:Int = rowsChanged.index(of: indexPath.row){
                rowsChanged.remove(at: indexOfDeletable)
                print("Removed from rowsChanged!")
            }
        }else{
            rowsChanged.append(indexPath.row)
            print("Added to rowsChanged!")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionArray.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func configureNavigation(){
        self.navigationItem.title = "Regions"
    }
    
    func getUserSubscriptionData(){
        
        // Clear subscriptionRegionArray
        subscriptionArray = []
        
        // 1. GET /organization/regions?organizationUUID=xx
        
        rxProvider
            .request(MidoriMoyaAPI.getOrganizationRegion(organizationUUID: organizationUUID!))
            .filterSuccessfulStatusCodes()
            .mapOptional(to: [OrganizationRegionSubscriptionResponse].self,keyPath:"data")
            .subscribe{ event -> Void in
                switch event{
                case .next(let results):
                
                    // Update self.subscriptionArray
                    for r in results!
                    {
                        let element = OrganizationRegionSubscription(regionID: r.id!, regionName: r.name!, isSubscribed: r.isSubscribed!)
                        self.subscriptionArray.append(element)
                    }
                    
                    // Update view with row data
                    self.tableView.reloadData()
                    
                case .error(let error):
                    print("ERROR!!!!")
                    print(error)
                default:
                    break
                }
            }.disposed(by: disposeBag)
        
    }
    
    func updateUserSubscriptionData(){
        
        // 3. POST /user/subscriptions?organizationID=xx
        
        var listOfUpdates: [Dictionary<String,AnyObject>] = []
        
        // Explicit Data Updates
        for indexOfRowChanged in rowsChanged{
            let obj = subscriptionArray[indexOfRowChanged]
            let quickDict:[String:AnyObject] = [
                "region_id": obj.regionID as AnyObject,
                "is_subscribed": obj.isSubscribed as AnyObject,
            ]
            listOfUpdates.append(quickDict)
        }
        
        // Return if no updates were made
        if listOfUpdates.isEmpty{
            return
        }
        
        rxProvider
            .request(MidoriMoyaAPI.postUserSubscriptionToggle(
                organizationUUID: organizationUUID!,
                updates: listOfUpdates)
            )
            .debug("PostUserSubscriptionToggle")
            .filterSuccessfulStatusCodes()
            .subscribe({ event -> Void in
                
                switch event{
                case .next(let results):
                    print(results)
                    
                    print("FINISH POST")

                case .error(let error):
                    print(error)
                    print("ERROR!!!")
                default:
                    break
                    
                }
            }).disposed(by: disposeBag)
    }
    
    
    @IBAction func updateOrganizationRegionSubscription(_ sender: AnyObject) {
        
        updateUserSubscriptionData()
        
        self.dismiss(animated: true, completion:nil)
        
    }
    
}
