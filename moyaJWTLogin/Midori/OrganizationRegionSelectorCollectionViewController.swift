//
//  OrganizationRegionSelectorCollectionViewController.swift
//  Midori
//
//  Created by Raymond Lam on 11/21/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import UIKit
import RxSwift

class OrganizationRegionSelectorCollectionViewController: UICollectionViewController {

    // Should be object
    var selected:String?
    
    let disposeBag = DisposeBag()
    var provider: Networking!
    var organizationRegionsArray:[OrganizationRegion] = []
    var organizationUUID: String?
    
    
    enum SegueIdentifier: String {
        case SegueToRegionalLocations = "showRegionalLocations"
        case SegueToRegionalPublications = "showRegionalPublications"
        case SegueToRegionalEvents = "showRegionalEvents"
    }
    
    enum ButtonIdentifier: String {
        case ButtonToLocation = "Location"
        case ButtonToPublication = "Publication"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupRx()
        
    }
    
    // Select a region to view locations / publications
    func configureView() {
        
        collectionView?.allowsMultipleSelection = false
        
        if let selectedCase = ButtonIdentifier(rawValue: selected!){
            switch selectedCase {
            case .ButtonToLocation:
                self.title = NSLocalizedString("Select a region to view locations", comment: "OrganizationRegionSelectorCVC")
            case .ButtonToPublication:
                self.title = NSLocalizedString("Select a region to view publications", comment: "OrganizationRegionSelectorCVC")
            }
        }
    }

    
    func setupRx() {
        provider = Networking.newDefaultNetworking()
        
        provider.request(.getOrganizationRegion(organizationUUID: organizationUUID!))
            .debug()
            .filterSuccessfulStatusCodes()
            .map(to: [OrganizationRegion].self, keyPath:"data")
            .subscribe{ (event) in
                switch event{
                case .next(let objects):
                    
                    self.organizationRegionsArray = objects
                    self.collectionView?.reloadData()
                    
                case .error(let error):
                    
                    print("Something went wrong with getting organizationRegions:: \(error)")
                    
                default: break
                }
            }.disposed(by: disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        
        return self.organizationRegionsArray.count
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegionCell", for: indexPath) as! OrganizationRegionSelectorCollectionViewCell
        
        cell.region = organizationRegionsArray[indexPath.row]
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        // What button was previously selected?
        // Publication/Location/Events?
        
        if let selectedCase = ButtonIdentifier(rawValue: selected!){
            switch selectedCase {
            case .ButtonToLocation:
                self.performSegue(withIdentifier: "showRegionalLocations", sender: self)
            case .ButtonToPublication:
                self.performSegue(withIdentifier: "showRegionalPublications", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("THE IDENTIFIER: \(segue.identifier!)")
        
        if let segueIdentifier =  SegueIdentifier(rawValue: segue.identifier!) {
            
            switch segueIdentifier {
            case .SegueToRegionalPublications:
                
                let dvc = segue.destination as! PhotoStreamViewController

                // obtain index path
                let indexPath: AnyObject? = self.collectionView?.indexPathsForSelectedItems!.last as AnyObject?
                
                // get organizationRegion
                let selectedResult:OrganizationRegion = self.organizationRegionsArray[(indexPath?.row)!]

                dvc.organizationRegionID = selectedResult.id
                dvc.setupWithDataType(type: .regionalPublications)
            
            case .SegueToRegionalLocations:
                
                // obtain index path
                let indexPath: AnyObject? = self.collectionView?.indexPathsForSelectedItems!.last as AnyObject?
                
                // get organizationRegion
                let selectedResult:OrganizationRegion = self.organizationRegionsArray[(indexPath?.row)!]
                
                let dvc = segue.destination as! RegionLocationTableViewController
                dvc.organizationUUID =  organizationUUID!
                dvc.organizationRegionID = selectedResult.id
                
            default:
                break
            }
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
