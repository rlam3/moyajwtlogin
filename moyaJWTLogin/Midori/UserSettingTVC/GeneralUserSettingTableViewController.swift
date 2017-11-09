//
//  GeneralUserSettingTableViewController.swift
//  Midori
//
//  Created by Raymond Lam on 4/9/17.
//  Copyright © 2017 Midori. All rights reserved.
//

import Foundation
import UIKit
import Static
import Eureka
import SafariServices

class GeneralUserSettingTableViewController: TableViewController {


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

    func configure() -> Void {
        title = NSLocalizedString("General", comment:"GeneralUserSettingTVC")
    }

    func configureDataSource() -> Void {

        dataSource.sections = [
            Section(header: "",
                    rows: [
                    Row(
                        text:NSLocalizedString("Privacy Policy", comment:"GeneralUserSettingTVC"),
                        selection:{

//                            let formVC = LanguageSelectFormViewController(style: .grouped)
//                            self.show(formVC, sender: self)
                            let _url = Config.sharedInstance.privacyURL()
                            let vc = SFSafariViewController(url: _url)
                            vc.hidesBottomBarWhenPushed = true
                            self.show(vc, sender: self)

                        },accessory:.disclosureIndicator),
                    Row(
                        text:NSLocalizedString("Terms and Condition", comment:"GeneralUserSettingTVC"),
                        selection:{

                            let _url = Config.sharedInstance.tosURL()
                            let vc = SFSafariViewController(url: _url)
                            vc.hidesBottomBarWhenPushed = true
                            self.show(vc, sender: self)

//                            let formVC = LanguageSelectFormViewController(style: .grouped)
//                            self.show(formVC, sender: self)

                    },accessory:.disclosureIndicator),
                    ]
            )
        ]

        dataSource.tableView = tableView

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}
