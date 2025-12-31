//
//  AppDelegate.swift
//  DonAte
//
//  ✅ UPDATED: Modern Firebase cache settings (no deprecation warnings)
//  Created by Claude on 31/12/2025.
//

import UIKit
import Firebase
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // ✅ CRITICAL: Configure Firebase FIRST before anything else
        FirebaseApp.configure()
        print("✅ Firebase configured successfully")
        
        // ✅ UPDATED: Use modern cache settings instead of deprecated isPersistenceEnabled
        let settings = FirestoreSettings()
        settings.cacheSettings = PersistentCacheSettings(sizeBytes: NSNumber(value: FirestoreCacheSizeUnlimited))
        Firestore.firestore().settings = settings
        print("✅ Firestore offline persistence enabled")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
    }
}
