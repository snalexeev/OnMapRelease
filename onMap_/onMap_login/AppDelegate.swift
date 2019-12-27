//

import UIKit
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func userIsLogin() -> Bool {
        //SettingOnMap.shared.userIsLogin = false
        return SettingOnMap.shared.userIsLogin
    }
    
    func rootMainTabBar() {
        var storyboard = UIStoryboard(name: "AccountViewController", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        storyboard = UIStoryboard(name: "MapViewController", bundle: nil)
        let vc2 = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let nc2 = UINavigationController(rootViewController: vc2)
        //storyboard = UIStoryboard(name: "SettingsViewController", bundle: nil)
        //let vc3 = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let tb = UITabBarController()
        tb.setViewControllers([vc1, nc2/*, vc3*/], animated: false)
        tb.selectedIndex = 1
        self.window?.rootViewController = tb
        self.window?.makeKeyAndVisible()
    }
    func rootLoginViewController() {
        let bounds = UIScreen.main.bounds
        self.window = UIWindow(frame: bounds)
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nc = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        rootMainTabBar()
        
//        let key = SettingOnMap.shared.userIsLogin
//        if key {
//            rootMainTabBar()
//        } else {
//            rootLoginViewController()
//        }
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

