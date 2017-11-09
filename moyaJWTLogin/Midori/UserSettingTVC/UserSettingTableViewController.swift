//
//  UserSettingTableViewController.swift
//  Midori
//
//  Created by Raymond Lam on 4/7/17.
//  Copyright © 2017 Midori. All rights reserved.
//

import Foundation
import UIKit
import Static
import SafariServices

class UserSettingTableViewController: TableViewController {


    override init(style: UITableViewStyle) {
        super.init(style: style)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureDataSource()

    }


    /// FIXME:
    func configureDataSource() -> Void {

        dataSource.sections = [
            Section(
                header: "",
                rows: [
                    Row(
                        text:NSLocalizedString("General", comment: "UserSettingsTVC"),
                        selection:{

                            let vc = GeneralUserSettingTableViewController(style: .grouped)
                            self.show(vc, sender: self)

                    },
                    accessory:.disclosureIndicator)
                ]
            ),
            Section(
                header: "",
                rows: [
                    Row(
                        text:NSLocalizedString("Help / Feedback", comment: "UserSettingsTVC"),
                        selection:{

                            let vc = SFSafariViewController(url: URL(string: Config.sharedInstance.contactUsURLString())!)
                            vc.hidesBottomBarWhenPushed = true
                            vc.title = NSLocalizedString("Contact Us", comment: "UserSettingsTVC")
                            self.show(vc, sender: self)

                        },accessory:.disclosureIndicator
                    ),
                    Row(
                        text:NSLocalizedString("About", comment: "UserSettingsTVC"),
                        selection:{
                            let vc = SFSafariViewController(url: URL(string: Config.sharedInstance.aboutURLString())!)
                            vc.hidesBottomBarWhenPushed = true
                            vc.title = NSLocalizedString("About Us", comment: "UserSettingsTVC")
                            self.show(vc, sender: self)
                        },accessory:.disclosureIndicator
                    )
                ]
            ),
            Section(
                header: "",
                rows: [
                    Row(
                        text:NSLocalizedString("Logout", comment: "UserSettingsTVC"),
                        selection:{

                            [unowned self] in

                            self.logOutClicked()

                        },accessory:.none,
                        cellClass:CustomTableViewCell.self
                    ),
                ]
            ),
        ]


        dataSource.tableView = tableView
    }

    func logOutClicked() -> Void {

        /// FIXME: Exiting app prior to logout prevents self.dismiss to work

        AuthManager.resetKeychain()
        UserDefaults.standard.setIsLoggedIn(value:false)

        self.tabBarController?.selectedIndex = 0

        let firstView = tabBarController?.viewControllers?[0] as? UINavigationController
        firstView?.popToRootViewController(animated: false)

//        self.navigationController?.popToRootViewController(animated: false)
//        self.dismiss(animated: true, completion: nil)
//        self.present((navigationController?.topViewController)!, animated: true, completion: nil)

    }


    func configure() -> Void {
        title = NSLocalizedString("Settings", comment: "UserSettingsTVC")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
