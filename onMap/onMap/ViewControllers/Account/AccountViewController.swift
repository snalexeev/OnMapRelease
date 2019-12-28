//
//  AccountViewController.swift
//  onMap
//
//  Created by Sergei Alexeev on 28.12.2019.
//  Copyright © 2019 onMap. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // скрытие навигатион контроллера
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func presentLoginViewController() {
        let vc = UIStoryboard(name: "LoginViewController", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let nc = UINavigationController.init(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }

    @IBAction func didClickLogOut(_ sender: Any) {
        tabBarController?.dismiss(animated: true, completion: {
            SettingOnMap.shared.userIsLogin = false
            self.presentLoginViewController()
        })
    }
}
