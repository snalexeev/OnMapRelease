 
//  AppDelegate.swift
//  onMap
//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func rootMainTabBar() {
        let vc1 = UIStoryboard(name: "AccountViewController", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        let nc1 = UINavigationController.init(rootViewController: vc1)
        let vc2 = UIStoryboard(name: "MapViewController", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let nc2 = UINavigationController.init(rootViewController: vc2)
//        let vc3 = UIStoryboard(name: "SettingsViewController", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
//        let nc3 = UINavigationController.init(rootViewController: vc3)
        let tb = UITabBarController()
        tb.setViewControllers([nc1, nc2/*, nc3*/], animated: true)
        tb.selectedIndex = 1
        
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        self.window?.rootViewController = tb
        self.window?.makeKeyAndVisible()
    }
    
    func rootLoginViewController() {
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        let vc = UIStoryboard(name: "LoginViewController", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nc = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        let key = SettingOnMap.shared.currentuserID
        if key != "" {
            rootMainTabBar()
            DispatchQueue.main.async {
                Account.shared.loadData()
            }
        } else {
            rootLoginViewController()
        }
        
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


}

