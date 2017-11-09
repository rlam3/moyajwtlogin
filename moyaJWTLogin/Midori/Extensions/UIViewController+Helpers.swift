//
//  UIViewController+Helpers.swift
//  Midori
//
//  Created by Raymond Lam on 4/13/17.
//  Copyright © 2017 Midori. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
