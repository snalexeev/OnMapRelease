//
//  AccountViewController.swift
//  onMap
//

import UIKit

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func didClickLogOut(_ sender: Any) {
        SettingOnMap.shared.userIsLogin = false
        //present login view controller
        dismiss(animated: true) {
            let storyboard = UIStoryboard(name: "LoginViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            let nc = UINavigationController(rootViewController: vc)
            nc.modalPresentationStyle = .fullScreen
            self.present(nc, animated: false)
        }
    }
}
