//
//  AppDelegate.swift
//  LazyMessages
//
//  Created by Brandon Reynier and Karina Teyssere on 18/11/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let id = response.notification.request.identifier
        print("Received notification with ID = \(id)")

        let defaults = UserDefaults.standard
        defaults.setValue(id, forKey: "SmsToSendFromNotif")
        
		NotificationCenter.default.post(name: Notification.Name("SmsToSendFromNotif"), object: nil)
		
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let id = notification.request.identifier
        print("Received notification with ID = \(id)")
//Apeller sendSms
        
        let defaults = UserDefaults.standard
        defaults.setValue(id, forKey: "SmsToSendFromNotif")
        
//        let message = CreateMessageViewController()
//        message.sendSms()
        
        completionHandler([.sound, .alert])
    }
}
