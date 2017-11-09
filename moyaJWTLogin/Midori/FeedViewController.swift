////
////  FeedViewController.swift
////  Midori
////
////  Created by Raymond Lam on 6/19/15.
////  Copyright (c) 2015 Midori. All rights reserved.
////
//
//import Foundation
//import UIKit
//import CollectionViewWaterfallLayout
//import AVFoundation
////import NilColorKit
////import FlatUIColors
//
//
//class FeedViewController: UIViewController, UICollectionViewDataSource, CollectionViewWaterfallLayoutDelegate {
//
//    var publications:[Publication]! = []
//
////    var userFeedWrapper:UserFeedWrapper? // holds the last wrapper we've loaded
//
//    var page = 1
//    var next_num:Int = 0
//    var total_items:Int = 0
//    var next_url:String?
//    var isLoading = false
//
//    let api = MidoriAPI()
//    var refreshControl: UIRefreshControl!
//
//    @IBOutlet var feedView: UICollectionView!
//
//    override func viewDidLoad() {
//
//        print("Entering FeedViewController")
//
//        // Laying out of collection view
//        let layout = CollectionViewWaterfallLayout()
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
//        layout.headerInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        layout.headerHeight = 20
//        layout.footerHeight = 20
//        layout.minimumColumnSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        layout.columnCount = 2
//
//        feedView.collectionViewLayout = layout
//
//        feedView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionHeader, withReuseIdentifier: "Header")
//        feedView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: CollectionViewWaterfallElementKindSectionFooter, withReuseIdentifier: "Footer")
//        feedView.delegate = self
//        feedView.dataSource = self
//        feedView.autoresizingMask = UIViewAutoresizing.flexibleHeight
//        feedView.layer.masksToBounds = false
//
//        // Set title on the FeedView
//        self.navigationItem.title = "My Subscriptions"
//
//        print("FeedViewController.viewDidLoad")
//
//        let userDefaults = UserDefaults.standard
//        let userNameFromUserDefaults = userDefaults.object(forKey: "userName") as! String!
//
//        // If nothing is being held inside userdefaults make them login
//        if userNameFromUserDefaults == nil || (userNameFromUserDefaults?.isEmpty)! || userNameFromUserDefaults == ""{
//            self.performSegue(withIdentifier: "showLogin", sender: self)
//
//        }else{
//            loadFirstUserFeed()
//        }
//
//
//        // Add pullToRefreshControls
////        self.refreshControl = UIRefreshControl()
////        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
////        self.refreshControl.addTarget(self, action: "didPullToRefresh:", forControlEvents: .ValueChanged)
////        self.feedView.addSubview(refreshControl)
//    }
//
//
//
//
//    func didPullToRefresh(_ refreshControl: UIRefreshControl){
//
//        // Clear out publications
//
//        // Empty out array of publication / userfeed
//        self.publications = Array<Publication>()
//        //reset pagination
//        self.page = 1
//        print("didPullToRefresh")
//        loadFirstUserFeed()
//        self.refreshControl.endRefreshing()
//    }
//
//    func loadFirstUserFeed(){
//        print("loadFirstUserFeed")
//        print("getUserFeed")
//
//        //MARK: For testing purposes we reduce page limit to 10 ensure pagination is working
//        // This will however compromise the user experience
//        // During production, please set the page_limit back up to 25
//
//        api.getUserFeed(self.page,page_limit: 10){ [weak self]
//
//            (response, error) in
//
//            guard let `self` = self else {
//                return
//            }
//
//            var jsonData:JSON
//
//            switch response.result{
//                case .Success:
//                    if let value = response.result.value{
//
//                        jsonData = JSON(value)
//
//                        // For pagination
//                        self.total_items = jsonData["page"]["total"].intValue
//                        self.next_num = jsonData["page"]["next_num"].intValue
//                        self.next_url = jsonData["page"]["next"].stringValue
//
//                        let responseFeed  = jsonData["data"].arrayValue
//
//                        // Create publication/userfeed objects
//                        for subJson in responseFeed {
//
//                            // FIXME: This would probably need to be deprecated in favor of userfeed
//                            let publication = Publication(json: subJson)
//
//                            // FIXME: CANNOT APPEND NSURL TO ARRAY
//                            for (_, fileJSON) in subJson["publication_files"]{
//
//                                let url_string = fileJSON["full_cdn_path"].stringValue
//
//                                let url = NSURL(string: url_string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
//                                publication.filesByURL.append(url!)
//
//                            }
//
//                            self.publications.append(publication)
//
//                        }
//
//                        self.feedView?.reloadData()
//
//                    }
//                case .Failure:
//                    
//                    print("Something broke here?")
//
//                    let alertView2 = UIAlertController(title: "Service Unavailable", message: "Sorry, the login feature is not available yet. Please retry later.", preferredStyle: UIAlertControllerStyle.Alert)
//
//
//                    let callActionHandler = {
//                        (action:UIAlertAction!) -> Void in
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    }
//
//
//                    let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: callActionHandler)
//                    alertView2.addAction(defaultAction)
//                    self.presentViewController(alertView2, animated: true, completion: nil)
//
//            }
//        }
//    }
//
//
//
//    // FIXME: Infinite Scrolling
//    //    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//    //
//    //        // scroll reached the bottom
//    //
//    //        let currentOffset = feedView.contentOffset.y
//    //        let maximumOffset = feedView.contentSize.height - feedView.frame.size.height
//    //
//    //        // Change 10.0 to adjust the distance from bottom
//    //        if (maximumOffset - currentOffset <= 44) {
//    //            // Continue to load more feed when the bottom of the feed is reached
//    //            loadUserFeed()
//    //        }
//    //
//    //    }
//
//
//
//    func loadMoreUserFeed(){
//
//        api.getUserFeedViaURL(self.next_url!){
//
//            (response, error) in
//
//            var jsonData:JSON
//
//            switch response.result{
//            case .Success:
//                if let value = response.result.value{
//
//                    jsonData = JSON(value)
//
//                    self.total_items = jsonData["page"]["total"].intValue
//                    self.next_num = jsonData["page"]["next_num"].intValue
//                    self.next_url = jsonData["page"]["next"].stringValue
//
//                    let responseFeed  = jsonData["data"]
//
//                    // Create publication objects
//                    for (_, subJson) in responseFeed {
//
//                        let publication = Publication(json: subJson)
//
//                        for (_, fileJSON) in subJson["publication_files"]{
//
//                            let url_string = fileJSON["full_cdn_path"].stringValue
//
//                            let url = NSURL(string: url_string.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
//
//                            print(url)
//                            publication.filesByURL.append(url!)
//
//
//                        }
//
//                        self.publications.append(publication)
//
//                    }
//
//                    self.feedView?.reloadData()
//
//                }
//            case .Failure:
//
//                let alertView2 = UIAlertController(title: "Service Unavailable", message: "Sorry, the login feature is not available yet. Please retry later.", preferredStyle: UIAlertControllerStyle.Alert)
//
//
//                let callActionHandler = {
//                    (action:UIAlertAction!) -> Void in
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                }
//
//
//                let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: callActionHandler)
//                alertView2.addAction(defaultAction)
//                self.presentViewController(alertView2, animated: true, completion: nil)
//
//            }
//        }
//    }
//
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//    }
//
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//
//        print("numberOfSectionsInCollectionView")
//
//        return 1
//    }
//
//
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        print("numberOfItemsInSection")
//
//        return self.publications.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = feedView.dequeueReusableCell(withReuseIdentifier: "feedCollectionViewCell", for: indexPath) as! FeedCollectionViewCell
//
//        cell.layer.shouldRasterize = true
//        cell.layer.rasterizationScale = UIScreen.main.scale;
//
//        // Get publicationObject
//        let publication = publications[indexPath.row]
//
//        // Configure what cell looks like
//
//        cell.configure(publication)
//
//        // Load more in background
//        if indexPath.row == self.publications.count - 4 {
//            if self.total_items > self.publications.count {
//                self.loadMoreUserFeed()
//            }
//        }
//
//
//        // See if we need to load more species
////        let rowsToLoadFromBottom = 5;
////        if indexPath.row >= (numberOfSpecies - rowsToLoadFromBottom) {
////            if let totalSpeciesCount = self.speciesWrapper?.count where totalSpeciesCount - numberOfSpecies > 0 {
////                self.loadMoreSpecies()
////            }
////        }
//
//
//
//        // Animate cell
////        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 1.0, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseIn,
////            animations: {
////                cell.alpha = 1.0
////            }, completion: nil)
//
//        return cell
//
//    }
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if(segue.identifier == "showPublicationPage"){
//
//            // obtain index path
//            let indexPath: AnyObject? = self.feedView?.indexPathsForSelectedItems!.last as AnyObject?
//
//            // get publication
//            let selectedResult = self.publications[indexPath!.row]
//
//            // prepare publication view controller
//            let pvc = segue.destination as! PublicationViewController
//
//            // pass objects to destination VC
////            pvc.publicationFiles = selectedResult.files
//            pvc.publicationID = selectedResult.id
//            pvc.publication = selectedResult
//
//            // Reset to page
//            // self.page = 1
//            //self.pageCount = 0
//
//
//        }
//
//        // Pushed to login view
////        if(segue.identifier == "showLogin"){
////
////            var lvc = segue.destinationViewController as! LoginViewController
////
////            lvc.tabBarController?.hidesBottomBarWhenPushed = true
////            lvc.hidesBottomBarWhenPushed = true
////
////        }
//
//
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        var reusableView: UICollectionReusableView? = nil
//
//        if kind == CollectionViewWaterfallElementKindSectionHeader {
//            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath)
//            if let _ = reusableView {
//
//                // Add things into Header
////                view.backgroundColor = FlatUIColors.greenSeaColor(1)
//
//
//            }
//        }
//        else if kind == CollectionViewWaterfallElementKindSectionFooter {
//            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
//            if let _ = reusableView {
////                view.backgroundColor = FlatUIColors.emeraldColor()
//            }
//        }
//
//        return reusableView!
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        print("You selected the following index: \(indexPath.row)")
//
//        performSegue(withIdentifier: "showPublicationPage",sender:self)
//
//        feedView.deselectItem(at: indexPath, animated: true)
//
//    }
//
//    
//    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
//
//        let publication = publications[indexPath.row]
//        return publication.topImageCoverSize
//
//    }
//
//}
//
//
//extension FeedViewController{
//    func clearUserFeed(){
//        self.publications = Array<Publication>()
//    }
//}
