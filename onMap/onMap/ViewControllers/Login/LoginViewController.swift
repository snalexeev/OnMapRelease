//
//  LoginViewController.swift
//  onMap
//
//  Created by Sergei Alexeev on 18.12.2019.
//  Copyright © 2019 onMapTeam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func didClickLogin(_ sender: Any) {
        
        //
        SettingOnMap.shared.userIsLogin = true
        
        
        var storyboard = UIStoryboard(name: "AccountViewController", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        storyboard = UIStoryboard(name: "MapViewController", bundle: nil)
        let vc2 = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let nc2 = UINavigationController(rootViewController: vc2)
        storyboard = UIStoryboard(name: "SettingsViewController", bundle: nil)
        let vc3 = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let tb = UITabBarController()
        tb.setViewControllers([vc1, nc2, vc3], animated: false)
        tb.selectedIndex = 1
        tb.modalPresentationStyle = .fullScreen
        present(tb, animated: true)
    }
    
}
