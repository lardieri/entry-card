//
//  SceneDelegate.swift
//  Entry Card
//

import UIKit
import BrightnessToggle

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }

        if lockObserver == nil {
            lockObserver = NotificationCenter.default.addObserver(forName: .lockUI, object: nil, queue: .main, using: lockUI(_:))
        }

        if unlockObserver == nil {
            unlockObserver = NotificationCenter.default.addObserver(forName: .unlockUI, object: nil, queue: .main, using: unlockUI(_:))
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).

        if let lockObserver {
            self.lockObserver = nil
            NotificationCenter.default.removeObserver(lockObserver)
        }

        if let unlockObserver {
            self.unlockObserver = nil
            NotificationCenter.default.removeObserver(unlockObserver)
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).

        BrightnessToggle.applicationWillResignActive()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.

        BrightnessToggle.applicationWillEnterForeground()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        if LockManager.shared.available && AppSettings.requireUnlock {
            if let rootVC = window?.rootViewController as? RootViewController {
                rootVC.lockImmediately()
            }
        }
    }

    private func lockUI(_: Notification) {
        if let rootVC = window?.rootViewController as? RootViewController {
            rootVC.lockUI()
        }
    }

    private func unlockUI(_: Notification) {
        if let rootVC = window?.rootViewController as? RootViewController {
            rootVC.unlockUI()
        }
    }

    private var lockObserver: NSObjectProtocol? = nil
    private var unlockObserver: NSObjectProtocol? = nil
}

extension NSNotification.Name {
    static let lockUI = NSNotification.Name("Entry Card - lock UI")
    static let unlockUI = NSNotification.Name("Entry Card - unlock UI")
}
