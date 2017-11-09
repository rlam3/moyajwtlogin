//
//  SearchTableViewCell.swift
//  Midori
//
//  Created by Raymond Lam on 4/16/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import Foundation
import UIKit
import Font_Awesome_Swift
import FlatUIColors


class SearchTableViewCell: UITableViewCell {
   
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var organizationName: UILabel!

//    @IBOutlet weak var numberOfSubscribers: UILabel!
//    @IBOutlet weak var numberOfPublications: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func configureNew(_ result: SearchResultMap) {
        organizationName.text = result.display_name
       
        let placeholderImage = UIImage(icon: FAType.FABuildingO, size: CGSize(width: 10, height: 10), textColor: FlatUIColors.midnightBlue(), backgroundColor: .clear)

        logoImage.kf.setImage(
            with: result.logo_url,
            placeholder: placeholderImage,
            options: [.transition(.fade(0.2))],
            progressBlock: nil,
            completionHandler: { (image, error, _, _) in
                
                if error != nil {
                    NSLog((error?.localizedDescription)!)
                }
                
                self.logoImage?.image = image
                
        })
        

    }
    
    
}
