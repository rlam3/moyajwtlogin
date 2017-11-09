//
//  FeedCollectionViewCell.swift
//  Midori
//
//  Created by Raymond Lam on 6/19/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

@IBDesignable
class FeedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var captionStackView: UIStackView!
    @IBOutlet weak var topCoverImage: UIImageView!
    @IBOutlet weak var feedTitle: UILabel!
    @IBOutlet weak var expiryDate: UILabel!
    @IBOutlet weak var organizationAndRegion: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!

    
    
    
    var publicationNew: PublicationFeedMap?{
        didSet{
            if let pub = publicationNew{
                configureNew(pub)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topCoverImage.kf.indicatorType = .activity
        activityIndicator.isHidden = true
        
    }

    // Apply Pinterest Layout Attributes
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }

    override func prepareForReuse() {
        
        topCoverImage.kf.cancelDownloadTask()
        topCoverImage.image = UIImage()
        
        feedTitle.text = ""
        expiryDate.text = ""
        organizationAndRegion.text = ""
        
    }
    
    
    // MARK: Configure cell
    func configureNew(_ publication:PublicationFeedMap){
        
//        print("CONFIGURATION OF CELLS")
    
        // Caption Inset
        captionStackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        captionStackView.isLayoutMarginsRelativeArrangement = true
        

        topCoverImage.kf.setImage(
            with: publication.top_cover.url,
            placeholder: UIImage(),
            options: nil,
            progressBlock: nil,
            completionHandler: { (image, error, _, _) in
              
                
                if error != nil {
                    NSLog((error?.localizedDescription)!)
                }
                
                self.topCoverImage.image = image
                
                
            })
        
        
        
        let dividerLine:CALayer = CALayer()
        dividerLine.backgroundColor = UIColor.lightGray.cgColor
        dividerLine.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1.0)
        captionStackView.layer.addSublayer(dividerLine)
        
        
        self.feedTitle.text = publication.title
        // Set Date of expiry
        // FIXME: formatting of date needs fixing
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //            formatter.dateFormat = "yyyy-MM-dd"
        //            let date = formatter.dateFromString(publication.expiryDate.description)
        
        
//        self.expiryDate.text = ""
        
        if publicationNew?.expiry_date == nil{
            expiryDate.text = "Sale never expires"
        }else{
            expiryDate.text = "Sales end on " + formatter.string(from: publication.expiry_date as! Date)
        }
        
        
        // Set Organization - Region
        organizationAndRegion.text = publication.organizationRegionString
        
        // Styling cell
        feedTitle.textAlignment = .left
        bringSubview(toFront: self.feedTitle)
        feedTitle.backgroundColor = UIColor.white
        
    }
    
}
