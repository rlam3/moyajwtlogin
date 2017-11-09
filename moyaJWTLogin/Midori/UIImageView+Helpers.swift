//
//  UIImageView+Helpers.swift
//  Midori
//
//  Created by Raymond Lam on 12/17/16.
//  Copyright © 2016 Midori. All rights reserved.
//

import UIKit

extension UIImageView {
    func changeImageColor(color:UIColor) -> UIImage
    {
        image = image!.withRenderingMode(.alwaysTemplate)
        tintColor = color
        return image!
    }
}
