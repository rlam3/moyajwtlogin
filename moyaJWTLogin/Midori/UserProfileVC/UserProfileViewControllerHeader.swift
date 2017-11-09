//
//  UserProfileViewControllerHeader.swift
//  Midori
//
//  Created by Raymond Lam on 12/24/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import Foundation
import UIKit
import FlatUIColors
import Kingfisher
import Font_Awesome_Swift

class UserProfileViewControllerHeader: UIView {

    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var userProfilePic: UIImageView!
    
    
    var userProfile: UserProfile?{
        didSet{
            configure()
            print("CONFIGURE HEADER!!!")
        }
    }
    
    func configure() {
        
        userFullName.text = userProfile!.user_full_name
        configure_profile_pic()

    }
    
    func configure_profile_pic() {
        
        // if url exists, pass in url to with:
//        userProfilePic.kf.setImage(
//            with: nil,
//            placeholder: UIImage(),
//            options: nil,
//            progressBlock: nil,
//            completionHandler: nil)
        
        userProfilePic.setFAIconWithName(
            icon: .FAUser,
            textColor: FlatUIColors.midnightBlue(),
            backgroundColor: .white,
            size: CGSize(width:170, height:170)
        )
        
        userProfilePic.image = imageByRoundingCornersOfImage(userProfilePic.image!)
        
    }
    
    
    func imageByRoundingCornersOfImage(_ image:UIImage) -> UIImage{
        userProfilePic?.layer.cornerRadius = userProfilePic!.frame.size.width / 2;
        userProfilePic?.clipsToBounds = true
        userProfilePic?.layer.borderWidth = 3.0
        userProfilePic?.layer.borderColor = FlatUIColors.midnightBlue().cgColor
        userProfilePic?.layer.backgroundColor = UIColor.white.cgColor
        return (userProfilePic?.image!)!
    }
    
    
    
}
