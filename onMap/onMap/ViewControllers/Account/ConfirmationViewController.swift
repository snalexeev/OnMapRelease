//
//  ConfirmationViewController.swift
//  onMap_login
//
//  Created by Екатерина on 01/12/2019.
//  Copyright © 2019 Екатерина. All rights reserved.
//

import UIKit

class ConfirmationViewController: UIViewController, AccountDelegateForConfirmation {
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var hintTextField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Const.accountback
        Account.shared.accountDelegateForConfirmation = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        Account.shared.deleteAccount(password: passwordField.text ?? " ")
    }
    
    func dismissConfirmation() {
        dismiss(animated: true, completion: nil)
    }
    
    func showErrorWithConfirmation(error: String) {
        let alert = UIAlertController(title: "Ошибка", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        passwordField.text = ""
        
    }


}
