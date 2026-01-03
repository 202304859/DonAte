//
//  SceneDelegate.swift
//  DonAte
//
//  Created by BP-36-201-04 on 03/12/2025.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
    scene: UIScene, willConnectTo session:
    UISceneSession, options connectionOptions:
    UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else
    { return }
    window = UIWindow(windowScene: windowScene)
    setRootViewController()
    window?.makeKeyAndVisible()
    }
    private func setRootViewController() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    // Check if user ID exists in UserDefaults
    if let userID = UserDefaults.standard.string(forKey: UserDefaultsKeys.userID), Auth.auth().currentUser != nil {
    // User is logged in - show Home screen
    if let homeVC = storyboard.instantiateViewController(withIdentifier: "DonorDashboardController") as? DonorDashboardController {
    window?.rootViewController = homeVC
    }
    } else {
    if let loginVC =
    storyboard.instantiateViewController(withIdentifier:
    "LoginViewController") as? LoginViewController {
    window?.rootViewController = loginVC
    }
    }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the /Users/bp-36-201-05/Desktop/DonAte/DonAte/DonAte/ViewController.swiftprovided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

