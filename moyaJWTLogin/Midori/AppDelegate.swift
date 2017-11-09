//
//  AppDelegate.swift
//  Midori
//
//  Created by Raymond Lam on 3/14/15.
//  Copyright (c) 2015 Midori. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import Cely

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Cely.setup(with: window!, forModel: User(), requiredProperties: [.token], withOptions: [
            .loginStoryboard: UIStoryboard(name: "Main", bundle: nil)
//            .homeStoryboard: UIStoryboard(name: "NonMain", bundle: nil)
        ])
        
        // Override point for customization after application launch.
        Fabric.with([Crashlytics.self])
        
        // add log destinations. at least one is needed!
//        let console = ConsoleDestination()  // log to Xcode Console
//        let file = FileDestination()  // log to default swiftybeaver.log file
//        file.logFileURL = URL(string:"file:///tmp/SwiftyBeaver.log")
//        let cloud = SBPlatformDestination(appID: "6JvY76", appSecret: "okqdgwthpon9hypro4zfgnk7swvvrld7", encryptionKey: "enkzckrggnpbzgak0xytJeRjmm6oFtvw")

//        console.minLevel = SwiftyBeaver.Level.debug
        
        // Console logging colors
//        console.levelColor.verbose = "fg255,0,255;"
//        console.levelColor.debug = "fg255,100,0;"
//        console.levelColor.info = ""
//        console.levelColor.warning = "fg255,255,255;"
//        console.levelColor.error = "fg100,0,200;"
//
        // use custom format and set console output to short time, log level & message
//        console.format = "$DHH:mm:ss$d $L $M"
        // or use this for JSON output: console.format = "$J"
        
        
        // add the destinations to SwiftyBeaver
//        swiftyBeaverLog.addDestination(console)
//        swiftyBeaverLog.addDestination(file)
//        swiftyBeaverLog.addDestination(cloud)
//
        
//        // MARK: Onboarding storyboard testing
//        
//        // this line is important
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        
//        // In project directory storyboard looks like Main.storyboard,
//        // you should use only part before ".storyboard" as it's name,
//        // so in this example name is "Main".
//        let storyboard = UIStoryboard.init(name: "Onboarding", bundle: nil)
//        
//        // controller identifier sets up in storyboard utilities
//        // panel (on the right), it called Storyboard ID
//        let viewController = storyboard.instantiateViewController(withIdentifier: "idOnboardingCollectionViewController") as! OnboardingCollectionViewController
//        
//        self.window?.rootViewController = viewController
//        self.window?.makeKeyAndVisible()
//        return true
        
//        UITabBar.appearance().backgroundColor = .white
//        UINavigationBar.appearance().backgroundColor = .white
        
//
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

