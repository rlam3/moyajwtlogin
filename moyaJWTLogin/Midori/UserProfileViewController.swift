//
//  UserProfileViewController.swift
//  Midori
//
//  Created by Raymond Lam on 6/9/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit
import FlatUIColors
import RxSwift

class UserProfileViewController: UIViewController {

    // MARK: IBOutlet

    @IBOutlet weak var navigationBar: UINavigationItem!
    
    @IBOutlet weak var userSettingButton: UIBarButtonItem!
    @IBAction func userSettingButtonClicked(_ sender: Any) {
        
        let vc = UserSettingTableViewController(style: .grouped)
        
        show(vc, sender: self)
        
    }
    
    
    @IBOutlet weak var userProfileHeaderSection: UserProfileViewControllerHeader!
    @IBOutlet weak var userProfileEcofootprintSection: UserProfileViewControllerEcoFootprint!
    
    // MARK: var
    
    var userProfile: UserProfile!
    let provider: Networking! = Networking.newDefaultNetworking()
    let disposeBag = DisposeBag()
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        setupRx()
    }
    
    ///
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupRx()
    }
    
    
    func setupRx() {
        provider.request(.getUserProfile())
        .debug()
        .filterSuccessfulStatusCodes()
        .map(to: UserProfile.self)
        .subscribe{ (event) in
            
            switch event{
            case .next(let object):
                
                self.userProfile = object
                self.configureSectionViews()
                
            case .error(let error):
                print("Need to handle error \(error)")
            default: break
            }
                
            }.disposed(by: disposeBag)
    }
    
    func configureSectionViews() {
        
        userProfileEcofootprintSection.userProfile = userProfile
        userProfileHeaderSection.userProfile = userProfile
    
    }
    
//    func displayAlert(_ title:String, error:String){
//        
//        let alertView = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.alert)
//        
//        let callbackHandler = {
//            
//            (action:UIAlertAction!) -> Void in
//            self.dismiss(animated: true, completion: nil)
//            
//        }
//        
//        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: callbackHandler)
//        alertView.addAction(defaultAction)
//        self.show(alertView)
//   
//    }
    

    ///
    func configureNavigationBar(){
        
        // Navigation bar title
        navigationBar.title = NSLocalizedString("Me", comment:"UserProfileView Navigation Bar Me")
        
    }

}
