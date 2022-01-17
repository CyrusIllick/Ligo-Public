//
//  AppDelegate.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/24/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import Firebase
import IQKeyboardManagerSwift



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //sets up firebase for the whole app
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.toolbarTintColor = .black
        Analytics.initMixpanel()

       if #available(iOS 10.0, *) {
                 // For iOS 10 display notification (sent via APNS)
                 UNUserNotificationCenter.current().delegate = self

                 let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                 UNUserNotificationCenter.current().requestAuthorization(
                   options: authOptions,
                   completionHandler: {_, _ in })
               } else {
                 let settings: UIUserNotificationSettings =
                 UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                 application.registerUserNotificationSettings(settings)
               }

               application.registerForRemoteNotifications()
        UNUserNotificationCenter.current().delegate = self
        StoreReviewHelper.incrementAppOpenedCount()
        return true
    }
    
    
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    static func MainUIView() -> UIView?{
        
            return UIApplication.shared.connectedScenes
                   .filter({$0.activationState == .foregroundActive})
                   .map({$0 as? UIWindowScene})
                   .compactMap({$0})
                   .first?.windows
                   .filter({$0.isKeyWindow}).first
    }
}
