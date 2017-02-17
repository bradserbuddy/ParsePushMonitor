//
//  AppDelegate.swift
//  ParsePush
//
//  Created by Bradley Serbus on 12/16/16.
//  Copyright © 2016 Bradley Serbus. All rights reserved.
//

import UIKit
import Parse
import Foundation


class MySessionDelegate : NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDataDelegate {
    var completionHandlers: [String: () -> Void] = [:]
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "c1f754e7-bfd5-4fb6-b416-896ba0c4a0c0"
            ParseMutableClientConfiguration.server = "https://api.parse.buddy.com/parse/"
        })
        
        Parse.initialize(with: parseConfiguration)
        
        return true
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
    
    func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let ci = PFInstallation.current();
        
        ci?.setDeviceTokenFrom(deviceToken);
        
        ci?.saveInBackground();
        
        print("didRegisterForRemoteNotificationsWithDeviceToken")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register for remote notifications: ", error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print(userInfo)
    
        let url = URL(string: "https://app.datadoghq.com/api/v1/events?api_key=d2fecbda4fff5fe1e0dd82980bae9492&application_key=16c917955e87bd526ff12ecd27d256c9ee3a9f66")

        //let delegate = MySessionDelegate()
 
        let session = URLSession.shared
        
        //let session = URLSession(configuration: URLSessionConfiguration.background(withIdentifier: "bgSessionConfiguration"), delegate: delegate,
          //                       delegateQueue: OperationQueue.main)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"title\":\"Parse Push\", \"text\": \"Success\", \"tags\": [\"application:Parse\", \"platform:iOS\"]}".data(using: String.Encoding.utf8)
        
        let task = session.dataTask(with: request) {
            (data, response, error) in

            guard let data = data, let _:URLResponse = response, error == nil else {
                print("error")
                return
            }
            
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            print(dataString!)
        }
        
        task.resume()
        
        //NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
        //PFPush.handle(userInfo)
    }
}
