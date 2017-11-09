 //
//  PhotoStreamViewController.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import AVFoundation
import FlatUIColors
import Async
import RxSwift
import Font_Awesome_Swift
import TinyConstraints
import DZNEmptyDataSet

let PER_PAGE_LIMIT = 10
let STARTING_PAGE = 1
 
class PhotoStreamViewController: UICollectionViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    // MARK: var
    var provider: Networking! = Networking.newDefaultNetworking()
    var disposeBag = DisposeBag()
    
    var publicationsNew: [PublicationFeedMap] = []
    var paginationNew: PublicationPaginationMap?
    
    var organizationRegionID: Int!
    
    let refreshControl = UIRefreshControl()
    
    enum DataType {
        case regionalPublications
        case userFeed
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Coming from logout button
        let userState = AuthManager.shared.currentUserState

        switch userState {
        case .loggedOut:
            NSLog("User State: Logged out")
            Async.main{
                
                // Need to present view controller within main thread in order to prevent
                // "Presenting view controllers on detached view controllers" error
                
                self.logoutUser()
            }
        default: break
        }
        
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        ///
        
        collectionView?.emptyDataSetSource = self
        collectionView?.emptyDataSetDelegate = self
        
        // This loads every time the view appears
        
        let userState = AuthManager.shared.currentUserState
        
        switch userState {
        case .loggedIn:

            NSLog("User State: Logged in")

            if organizationRegionID == nil{
                setupWithDataType(type: .userFeed)
            }

            setupViewLayout()
            
        default:
            
            // If token is expired and user is not logged in
            Async.main{
                
                // Need to present view controller within main thread in order to prevent
                // "Presenting view controllers on detached view controllers" error
                
                self.logoutUser()
            }
        }
    }

    
    func logoutUser() -> Void {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "idLoginViewController") as! LoginViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl){
        
        publicationsNew.removeAll()
        paginationNew = nil
        collectionView?.reloadData()

        if organizationRegionID == nil{
            setupWithDataType(type: .userFeed)
        }else{
            setupWithDataType(type: .regionalPublications)
        }
        
        if publicationsNew.count > 0{
            refreshControl.endRefreshing()
        }else{
            refreshControl.endRefreshing()
        }
        
    }
    
    
    func setupWithDataType(type:DataType) {
        switch type {
        case .regionalPublications:
            
            self.navigationItem.title = "Region Publications"
            loadRegionalPublication(more:false)
            
        default:
            
            self.navigationItem.title = NSLocalizedString("My Feed", comment:"PhotoStreamVC nav title")
            refreshUserFeed()
        }
    }
    
    func loadRegionalPublication(more:Bool) {
        
        var rx_request: MidoriMoyaAPI!
        
        if more{
            rx_request = MidoriMoyaAPI.getRegionalPublications(regionID: organizationRegionID, page: paginationNew!.next_num, limit: 10)
        }else{
            rx_request = MidoriMoyaAPI.getRegionalPublications(regionID: organizationRegionID, page: 1, limit: 10)
        }
        
        provider.request(rx_request)
        .filterSuccessfulStatusCodes()
            .map(to: UserPublicationFeedMap.self)
        .subscribe{ (event) in
            switch event{
            case .next(let object):
                
                self.paginationNew = object.publicationPagination
                self.publicationsNew.append(contentsOf:object.publications)
                
                            
                print("RELOADED COLLECTION VIEW!!!")
                
                self.collectionView?.collectionViewLayout.invalidateLayout()
                self.collectionView?.reloadData()
                
            case .error(let error):
                self.handleFeedErrorAlert(error: error)
            default: break
            }
            }.disposed(by: disposeBag)
    }

    
    func loadUserFeed() {
        refreshUserFeed()
    }
    
    func refreshUserFeed(){
        
        fetchFeed(aPage: STARTING_PAGE)
        .subscribe{ event in
            self.handleUserFeedEvent(aEvent: event)
            }.disposed(by: disposeBag)
        
    }
    
    func loadMoreUserFeed(){
        
        fetchFeed(aPage: paginationNew!.next_num)
        .subscribe{ event in
            self.handleUserFeedEvent(aEvent: event)
            }.disposed(by: disposeBag)
    }

    func handleUserFeedEvent(aEvent:Event<UserPublicationFeedMap?>){
        switch aEvent{
        case .next(let object):
            // Set pagination and publications
            
            
            //FIXME: fatal error: unexpectedly found nil while unwrapping an Optional value
            self.paginationNew = object!.publicationPagination
            
            self.publicationsNew.append(contentsOf: object!.publications)
            print("RELOADED COLLECTION VIEW!!!")
            Async.main{
                self.collectionView?.collectionViewLayout.invalidateLayout()
                self.collectionView?.reloadData()
                
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
            }
        case .error(let error):
            self.handleFeedErrorAlert(error:error)
        default:
            break
        }
    }
    
    
    func fetchFeed(aPage:Int) -> Observable<UserPublicationFeedMap?> {
        
        return provider.request(.getUserFeed(page: aPage, limit: PER_PAGE_LIMIT))
            .filterSuccessfulStatusCodes()
            .mapOptional(to: UserPublicationFeedMap.self)
        
    }
    
    
    
    ///
    func handleFeedErrorAlert(error:Error) {
        
        print("HANDLE FEED ERROR ALERT error: \(error.localizedDescription)")
        
        
        let alertView2 = UIAlertController(
            title: "Service Unavailable",
            message: "Sorry for inconvienence. Please retry later.",
            preferredStyle: UIAlertControllerStyle.alert
        )
        
        let callActionHandler = {
            (action:UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: {
                
                // Authentication Reset
                AuthManager.resetKeychain()
                UserDefaults.standard.setIsLoggedIn(value:false)
                
                let vc:LoginViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "idLoginViewController") as! LoginViewController
                
                let topvc = UIApplication.topViewController(controller: self.presentedViewController)
                
                topvc?.present(vc, animated: true, completion: nil)
                
                
            })
        }
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: callActionHandler)
        alertView2.addAction(defaultAction)
        self.present(alertView2, animated: true, completion: nil)
    }
    
    
}

/// MARK Extension for DZNEmptyDataSet Cocoapod to work
extension PhotoStreamViewController {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let attrs: [NSAttributedStringKey : Any] = [
            .font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline),
            .foregroundColor: FlatUIColors.midnightBlue()
        ]
        
        return NSAttributedString(string: "This is your feed", attributes: attrs)
    }

    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attrs: [NSAttributedStringKey : Any] = [
            .font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.footnote),
            .foregroundColor: FlatUIColors.midnightBlue()
        ]
        return NSAttributedString(string: "When you subscribe to some grocers, their latest posts will show up here!", attributes: attrs)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let imageIcon = UIImage.init(icon: .FALeanpub,
                                     size: CGSize(width: 150, height: 150),
                                     textColor: FlatUIColors.midnightBlue(),
                                     backgroundColor: .clear
        )
        
        return imageIcon
        
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
 

extension PhotoStreamViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.publicationsNew.count
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnotatedCollectionViewCell", for: indexPath) as! FeedCollectionViewCell

        // Set this for the collectionView
        cell.publicationNew = publicationsNew[indexPath.item]

        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale;

        /// Load more in background
        /// When reaching the 6th item on the list

        print("indexPath.row: \(indexPath.row) == \((self.publicationsNew.count) - 4)")

        if indexPath.row == (self.publicationsNew.count) - 4 {
            
            // Get More User Feed
            
            print("Should get More user Feed")
            
            if (self.paginationNew?.total)! > (self.publicationsNew.count) {
            
                
                if organizationRegionID != nil{
                    self.loadRegionalPublication(more:true)
                }else{
                    self.loadMoreUserFeed()
                }
                
                print("SHOULD BE LOADING MORE USER FEED HERE")
                
            }
        }
        
        return cell
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected the following index: \(indexPath.row)")
        performSegue(withIdentifier: "showPublicationPage", sender:self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        print("preparing for segue")
        
        if(segue.identifier == "showPublicationPage"){

            // MARK: PublicationViewController
            
            // obtain index path
            let indexPath: AnyObject? = self.collectionView?.indexPathsForSelectedItems!.last as AnyObject?

            // get publication
            let selectedResult:PublicationFeedMap = self.publicationsNew[(indexPath?.row)!]

            // prepare publication view controller
            let pvc = segue.destination as! PublicationViewController
            pvc.publicationNew = selectedResult

        }
    }
}

extension PhotoStreamViewController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(_ collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath , withWidth width:CGFloat) -> CGFloat {
        let publication = publicationsNew[indexPath.item]
        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect  = AVMakeRect(aspectRatio: (publication.top_cover.size), insideRect: boundingRect)
        
        
//        print("REC HEIGHT FOR PHOTO \(rect.height)")
        
        return rect.height
    }

    // 2. Returns the annotation size based on the text
    func collectionView(_ collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        let annotationPadding = CGFloat(5)
        let annotationHeaderHeight = CGFloat(18)

        let publication = publicationsNew[indexPath.item]
        let font = UIFont(name: "Helvetica", size: 10)!
        let commentHeight = publication.heightForCaption(font, width: width)
        let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        
//        print("HEIGHT OF ANNOTATION: \(height)")
        
        return height
    }
}
