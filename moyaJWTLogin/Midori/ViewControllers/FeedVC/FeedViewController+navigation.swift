//
//  FeedViewController+navigation.swift
//  Midori
//
//  Created by Raymond Lam on 1/17/17.
//  Copyright © 2017 Midori. All rights reserved.
//

import Foundation
import UIKit
import FlatUIColors

extension PhotoStreamViewController{

    func setupViewLayout() {
        
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        
        // Setup Collection View
        view.backgroundColor = FlatUIColors.clouds()
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.contentInset = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
        
        // Setup navigation bar
        setupNavigationBar()
        
        // Setup tab bar
        setupTabbar()
        
        // Setup Collection View Refresh controls
        setupRefreshControls()
        
    }
    
    func setupTabbar() {
        
        self.tabBarController?.tabBar.items?.first?.setFAIcon(icon: .FALeanpub)
        self.tabBarController?.tabBar.items?.first?.title = NSLocalizedString("Feed", comment: "FeedVC Nav Bar Item")
        
        let centerItem = self.tabBarController?.tabBar.items?[1]
        centerItem?.setFAIcon(icon: .FASearch)
        centerItem?.title = NSLocalizedString("Discover", comment: "FeedVC Nav Bar Item")
        
        self.tabBarController?.tabBar.items?.last?.setFAIcon(icon: .FAUser)
        self.tabBarController?.tabBar.items?.last?.title = NSLocalizedString("Me", comment: "FeedVC Nav Bar Item")
        
        self.tabBarController?.tabBar.tintColor = FlatUIColors.nephritis()
        
        self.tabBarController?.tabBar.backgroundColor = .white
        self.tabBarController?.tabBar.isTranslucent = false
        
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
    }
    

 func setupRefreshControls(){
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(PhotoStreamViewController.didPullToRefresh(_:)), for: UIControlEvents.valueChanged)
        
        refreshControl.tintColor = FlatUIColors.midnightBlue()
        // Assigning subview and refresh control are the same
//        collectionView?.addSubview(refreshControl)
        collectionView?.refreshControl = refreshControl
    }
    
}
