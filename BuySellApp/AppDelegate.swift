//
//  AppDelegate.swift
//  BuySellApp
//
//  Created by Sanzid on 2/20/19.
//  Copyright © 2019 Sanzid. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 200.0
        GIDSignIn.sharedInstance().clientID = "783557886515-jatf9dva5bv250qn0ia4pt0gi9ge79lt.apps.googleusercontent.com"
        self.window = UIWindow(frame: UIScreen.main.bounds)
        if (UserDefaults.standard.value(forKey: "ID2"))as? String != nil {
            
            let storyBoard = UIStoryboard(name: "Home", bundle: nil)
            var vc : UIViewController
            vc = storyBoard.instantiateViewController(withIdentifier: "page4")
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        else{
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            var vc : UIViewController
            vc = storyBoard.instantiateInitialViewController()!
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        
        let faceBook =  FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        
        let Google =  GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
        
        return  faceBook || Google
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
