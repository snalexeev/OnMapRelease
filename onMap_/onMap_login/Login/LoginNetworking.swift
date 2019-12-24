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
    func showAlert(title: String, message: String)
    func loginCompleted()
    func ifUserExists()
}
class LoginNetworking{
    private init() {}
    public static let shared = LoginNetworking()
    var loginDelegate: LoginDelegate?
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
                print(Auth.auth().currentUser?.uid)
                self.loginDelegate?.loginCompleted()
            }
            else{
                self.loginDelegate?.showAlert(title: "Ошибка входа", message: error?.localizedDescription ?? "Неверный email или пароль")
            }
            
        }
        
    }
    func checkUser(){
        if Auth.auth().currentUser != nil{
            loginDelegate?.ifUserExists()
        }
    }
}
