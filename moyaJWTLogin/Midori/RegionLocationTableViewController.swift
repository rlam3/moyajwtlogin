//
//  RegionLocationTableViewController.swift
//  Midori
//
//  Created by Raymond Lam on 11/21/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import UIKit
import FlatUIColors
import RxSwift
import MapKit
import CoreLocation

class RegionLocationTableViewController: UITableViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var organizationRegionLocations:[OrganizationRegionLocation] = []
    
    var provider: Networking!
    let disposeBag = DisposeBag()
    var organizationUUID: String!
    var organizationRegionID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        setupRx()
        determineMyCurrentLocation()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    func setupRx() {
        provider = Networking.newDefaultNetworking()
        provider.request(.getOrganizationLocations(
                                organizationUUID: organizationUUID,
                                regionID: organizationRegionID)
        )
        .filterSuccessfulStatusCodes()
        .map(to: [OrganizationRegionLocation].self, keyPath: "data")
        .subscribe{ (event) in
            switch event{
            case .next(let objects):
                self.organizationRegionLocations = objects
                self.tableView.reloadData()
            case .error(let errors):
                print("handler errors: \(errors.localizedDescription)")
            default: break
            }
            }.disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizationRegionLocations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! RegionLocationTableViewCell

        let selectedResult:OrganizationRegionLocation = organizationRegionLocations[indexPath.row]
        
        cell.location = selectedResult
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selection = organizationRegionLocations[indexPath.row]
        let addressString = selection.fullAddress()
        let cleanedString = addressString.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)

        
        let choose = UIAlertController(title: NSLocalizedString("Open with ", comment: "RegionLocationTVC alert title"), message: nil, preferredStyle: .actionSheet)
        
        let googleMapAction = UIAlertAction(title: "Google Maps",
                                            style: .default,
                                            handler: { _ in
            
                                                self.goToMap(navigateWith: .googleMaps, destinationAddress: cleanedString)
                                                
                                })
        let appleMapAction = UIAlertAction(title: "Apple Maps",
                                            style: .default,
                                            handler: { _ in
                                                
                                                self.goToMap(navigateWith: .appleMaps, destinationAddress: cleanedString)
                                                
        })
        let cancelAction = UIAlertAction(title: "Cancel",
                                           style: .cancel,
                                           handler: { _ in
                                            
        })
        
        
        // For iPad 
        choose.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        choose.popoverPresentationController?.sourceRect = CGRect(x: 400, y: 35, width: 100, height: 100)
        choose.popoverPresentationController?.permittedArrowDirections = [.left]
        
        choose.addAction(appleMapAction)
        choose.addAction(googleMapAction)
        choose.addAction(cancelAction)
        
        self.present(choose, animated: true, completion: nil)

    }

    
    enum NavigationChoices: String{
        case googleMaps
        case appleMaps    }
    
    
    func determineMyCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
        
//        locationManager.stopUpdatingLocation()
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        // manager.stopUpdatingLocation()
        
//        print("user latitude = \(currentLocation.coordinate.latitude)")
//        print("user longitude = \(currentLocation.coordinate.longitude)")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func goToMap(navigateWith:NavigationChoices, destinationAddress:String) {
        
        /// Obtain current coordinates with location services
                
//        swiftyBeaverLog.debug("Destination Address: \(destinationAddress))")
        
        switch navigateWith {
        case .appleMaps:
            if (UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!)) {

                NSLog("Opening Apple Maps")
                let url = "http://maps.apple.com/maps?daddr=\(destinationAddress)&saddr=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)"
                NSLog("Apple Maps URL: %@", url)

                UIApplication.shared.open(URL(string:url)!, options: [:], completionHandler: nil)

            } else {
                NSLog("Can't open Google Maps")
            }
            
        case .googleMaps:
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                NSLog("Opening Google Maps")
                let url = "comgooglemaps://?daddr=\(destinationAddress)&saddr=\(currentLocation.coordinate.latitude),\(currentLocation.coordinate.longitude)&views=traffic"
                NSLog("Google Maps URL: %@", url)
                UIApplication.shared.open(URL(string:url)!)
            } else {
                NSLog("Can't open Google Maps")
            }
       
        }
     
        /// Once goToMap has been clicked location updating should immediately stop
        locationManager.stopUpdatingLocation()
        
    }
    

    
}
