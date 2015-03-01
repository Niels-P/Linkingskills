//
//  AppDelegate.swift
//  MissingSkills
//
//  Created by Niels Pijpers on 06-02-15.
//  Copyright (c) 2015 NielsP. All rights reserved.
//

import UIKit
import OAuthSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UIWebViewDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.magentaColor()], forState:.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.redColor()], forState:.Selected)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        Parse.setApplicationId("lei67QowffEix6q5x8V35L0lgC7N83WLCpGEruIB", clientKey: "EM5Sz9nFJFNZADV7MOYIx1TXWfRoaVH3xrHoTSBq")
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = (.Alert | .Badge | .Sound)
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
        }
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("didRegisterForRemoteNotificationsWithDeviceToken")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        println("failed to register for remote notifications:  (error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
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
    
    
    func application(application: UIApplication!, openURL url: NSURL!, sourceApplication: String!, annotation: AnyObject!) -> Bool {
        println(url)
        if (url.host == "oauth-callback") {
            if (url.path!.hasPrefix("/twitter") || url.path!.hasPrefix("/flickr") || url.path!.hasPrefix("/fitbit")
                || url.path!.hasPrefix("/withings") || url.path!.hasPrefix("/linkedin")) {
                    OAuth1Swift.handleOpenURL(url)
            }
            if ( url.path!.hasPrefix("/github" ) || url.path!.hasPrefix("/instagram" ) || url.path!.hasPrefix("/foursquare") || url.path!.hasPrefix("/dropbox") || url.path!.hasPrefix("/dribbble") ) {
                OAuth2Swift.handleOpenURL(url)
            }
        }
        return true
    }
    



}

