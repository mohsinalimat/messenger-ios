//
//  AppDelegate.swift
//  Pulse
//
//  Created by Luke Klinker on 12/31/17.
//  Copyright © 2017 Luke Klinker. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import UserNotifications

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate : UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        AppOpenedUpdateHelper.checkForConversationListUpdate()
        FcmHandler.notifyAppForegrounded()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillResignActive(_ application: UIApplication) { }
    func applicationDidEnterBackground(_ application: UIApplication) { }
    func applicationDidBecomeActive(_ application: UIApplication) { }
    func applicationWillTerminate(_ application: UIApplication) { }
    
    func handleFcm(fcm: [AnyHashable: Any]) {
        if let operation = fcm["operation"] as? String,
            let content = fcm["contents"] as? String {
            if let dataFromString = content.data(using: .utf8, allowLossyConversion: false) {
                do {
                    let json = try JSON(data: dataFromString)
                    FcmHandler.handle(operation: operation, json: json)
                } catch { }
            }
        }
    }
}

extension AppDelegate {
    
    //
    // FCM messages coming through APNs, in the background. These are "silent" notitifications.
    //
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        handleFcm(fcm: userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //
    // FCM messages that will generate a notification
    //
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let _ = notification.request.content.userInfo
        completionHandler([])
    }
}

extension AppDelegate: MessagingDelegate {

    //
    // this is where notifications would usually come in, when the app is in the foreground.
    // Since I have used silent push notifications through APNs and told FCM about the APNs (above), notifications
    // haven't come through here. They *may* start coming through here when I stop using the silent notifications
    // (since they seem to be rate limited and restricted).
    //
    // Silent notifications will be used for dismissing a notification so that we can do that from the background.
    // Display notifications will be used for new messages (only received messages)
    // Normal FCM notifications will be used for everything else.
    //
    
    func application(received remoteMessage: MessagingRemoteMessage) {
        handleFcm(fcm: remoteMessage.appData)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        if Account.updateFcmToken(token: fcmToken) {
            PulseApi.devices().updateFcmToken(fcmToken: fcmToken)
        }
    }
}
