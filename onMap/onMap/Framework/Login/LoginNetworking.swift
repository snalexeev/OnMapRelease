//
//  LoginNetworking.swift
//  onMap_login
//
//  Created by Екатерина on 02/12/2019.
//  Copyright © 2019 Екатерина. All rights reserved.
//

import Foundation
import Firebase
protocol LoginDelegate {
    func showAlertWithError(title: String, message: String)
    func loginCompleted()
}
class LoginNetworking{
    private init() {}
    public static let shared = LoginNetworking()
    var loginDelegate: LoginDelegate?
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
                SettingOnMap.shared.currentuserID = Auth.auth().currentUser?.uid ?? ""
                self.loginDelegate?.loginCompleted()
            }
            else{
                self.loginDelegate?.showAlertWithError(title: "Ошибка входа", message: error?.localizedDescription ?? "Неверный email или пароль")
            }
            
        }
        
    }
    func resetPassword(email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                //
            }
        }
    }
}
