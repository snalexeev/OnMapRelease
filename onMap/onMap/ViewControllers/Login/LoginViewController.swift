//
//  LoginViewController.swift
//  onMap
//


import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // скрытие навигатион контроллера
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func presentMainTabBar() {
        let vc1 = UIStoryboard(name: "AccountViewController", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        let nc1 = UINavigationController.init(rootViewController: vc1)
        let vc2 = UIStoryboard(name: "MapViewController", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let nc2 = UINavigationController.init(rootViewController: vc2)
        let vc3 = UIStoryboard(name: "SettingsViewController", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let nc3 = UINavigationController.init(rootViewController: vc3)
        let tb = UITabBarController()
        tb.setViewControllers([nc1, nc2, nc3], animated: true)
        tb.selectedIndex = 1
        
        tb.modalPresentationStyle = .fullScreen
        present(tb, animated: false)
    }
    
    @IBAction func didClickLogIn(_ sender: Any) {
        
        
        
        
        
        SettingOnMap.shared.userIsLogin = true
        self.presentMainTabBar()
        
    }
}
