//
//  PublicationViewController.swift
//  Midori
//
//  Created by Raymond Lam on 3/29/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

typealias PublicationNew = PublicationFeedMap

class PublicationViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    var publicationNew: PublicationNew!
    
    
    // FIXME: currently unused variable
    var publicationID:Int?
    
    fileprivate var pageViewController: UIPageViewController?
    var currentIndex: Int = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        edgesForExtendedLayout = UIRectEdge()
        
        createPageViews()
        setupPageControl()
        
    }
    
    func createPageViews(){
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: PublicationPageView = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        
        pageViewController!.setViewControllers(viewControllers as? [UIViewController], direction: .forward, animated: false, completion: .none)
        
        //pageViewController!.setViewControllers(viewControllers as [AnyObject] as [AnyObject], direction: .Forward, animated: false, completion: nil)
        
        // FIXME: this is only way for us to see UIPageControl
        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width,  height: view.bounds.height)
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
//        pageViewController!.didMove(toParentViewController: self)

    }
    
    func setupPageControl(){
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.lightGray
        appearance.currentPageIndicatorTintColor = UIColor.darkGray
        appearance.backgroundColor = UIColor.clear
    }
    
    // MARK: viewControllerAtIndex
    func viewControllerAtIndex(_ index:Int) -> PublicationPageView?{
        
        if self.publicationNew.pulication_files.count == 0 || index >= self.publicationNew.pulication_files.count{
            return nil
        }
        
        let pageContentViewController = PublicationPageView()
        pageContentViewController.pageIndex = index
        
        // Ensure the UIImageView is empty prior to setting the image inside
//        pageContentViewController.publicationImageView = UIImageView()
        
        let url:URL = self.publicationNew.pulication_files[index].url
        
        pageContentViewController.publicationImageView.kf.indicatorType = .activity
        pageContentViewController.publicationImageView?.kf.setImage(
            with: url,
            placeholder: UIImage(),
            options: [.transition(.fade(0.2))],
            progressBlock: nil,
            completionHandler: { (image, error, _, _) in
                
                if error != nil {
                    NSLog((error?.localizedDescription)!)
                }
                
                pageContentViewController.publicationImageView?.image = image
                
        })
 
        currentIndex = index
        return pageContentViewController
        
    }
    
    

    // MARK: pageViewController
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PublicationPageView).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PublicationPageView).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1

        if (index == self.publicationNew.pulication_files.count){
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int
    {

        return self.publicationNew.pulication_files.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
}
    
