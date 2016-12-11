//
//  AppDelegate.swift
//  this_bores_me
//
//  Created by Emmet Susslin on 12/10/16.
//  Copyright © 2016 Emmet Susslin. All rights reserved.

//parse-dashboard --appId thisBoresMe --masterKey hesameanonemrgrinch --serverURL "http://thisboresme.herokuapp.com/parse"
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // configuration of using Parse code in Heroku
        
        let parseConfig = ParseClientConfiguration {
            (ParseMutableClientConfiguration) in
            
            // accessing Heroku App via id & keys
            ParseMutableClientConfiguration.applicationId = "this-bores-me"
            ParseMutableClientConfiguration.clientKey = "lordofthebored"
            ParseMutableClientConfiguration.server = "http://this-bores-me.herokuapp.com/parse"
        }
        
        Parse.initializeWithConfiguration(parseConfig)
        
        // call login function
        login()
        
        // color of window
        window?.backgroundColor = UIColor.whiteColor()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func login() {
        let username : String? = NSUserDefaults.standardUserDefaults().stringForKey("username")
        
        // if logged in
        if username != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let myTabBar = storyboard.instantiateViewControllerWithIdentifier("tabBar") as! UITabBarController
            
            window?.rootViewController = myTabBar
        }
    }



}

