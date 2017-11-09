//
//  PublicationPageView.swift
//  Midori
//
//  Created by Raymond Lam on 4/3/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit

class PublicationPageView: UIViewController, UIScrollViewDelegate{
    
    var pageIndex:Int = 0
    var publicationImageView:UIImageView!
    var scrollView:UIScrollView!
    
    

    init(){
        
        publicationImageView = UIImageView()
        super.init(nibName:nil, bundle:nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        publicationImageView.contentMode = UIViewContentMode.scaleAspectFit
        
        // Need to reposition the image
//        publicationImageView.frame = CGRectMake(0, 64, view.frame.width, view.frame.height-150)
        
        // Per page image frame
//        publicationImageView.backgroundColor = UIColor.redColor()
        
        // Create scrollView
        // width and height should only follow the frame of itself.
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-150 ))
        publicationImageView.frame = scrollView.frame
        
        //Add UIImageview into scrollview
        scrollView.addSubview(publicationImageView)
        scrollView.contentMode = UIViewContentMode.scaleAspectFit
        scrollView.maximumZoomScale = 5.0
        scrollView.minimumZoomScale = 1.0
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.clipsToBounds = true
        
        self.view = scrollView
    
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.publicationImageView
    }
    
    
    
}
