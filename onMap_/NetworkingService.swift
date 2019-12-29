//

import Foundation
import UIKit
import Firebase
protocol PhoneCheckDelegate{
    func checkingReturn(b: Bool)
}
protocol ShowAlertDelegate {
    func showAlert(title: String, message: String)
    func showNext()
}
class NetworkingService{
    private init() {}
    public static let shared = NetworkingService()
    var showAlertDelegate: ShowAlertDelegate?
    var showChecked: PhoneCheckDelegate?
    var user: User = User()
    var title: String = ""
    var message: String = ""
    let success: String = "Success"
    
    func signUpUser(name: String, surname: String, email: String, password: String, reppassword: String){
        title = success
        message = success
        if (name.isEmpty || surname.isEmpty || email.isEmpty || password.isEmpty || reppassword.isEmpty){
            title = "Ошибка"; message = "Заполните все поля"
            self.showAlertDelegate?.showAlert(title: self.title, message: self.message)
            return
        }
        if reppassword != password{
            title = "Ошибка"; message = "Пароли не совпадают"
            self.showAlertDelegate?.showAlert(title: self.title, message: self.message)
            return
        }
        user.name = name
        user.surname = surname
        user.email = email
        user.password = password
        let credential = EmailAuthProvider.credential(withEmail: user.email, password: user.password)
        Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
            if error == nil{
                if let result = result{
                    let refToDataBase = Database.database().reference().child("users")
                    refToDataBase.child(result.user.uid).updateChildValues(["name": self.user.name, "email": self.user.email, "surname": self.user.surname])
                }
            }
            else{
                self.message = String(error!.localizedDescription)
                self.title = "Ошибка"
            }
            
            if self.message == self.success{
                self.showAlertDelegate?.showNext()
            }
            else{
                self.showAlertDelegate?.showAlert(title: self.title, message: self.message)
            }
        })
        
    }
    func sendCode(text: String){
        let phoneNumber  = text
        print(phoneNumber)
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {  (verificationID, error) in
            if error == nil{
                UserDefaults.standard.removeObject(forKey: "authVerificationID")
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            }
            else{
                print(error?.localizedDescription)
            }
        }
    }
    func check(codeForCheck: String){
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "0"
        //UserDefaults.standard.set(codeForCheck, forKey: "authVerificationCode")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: codeForCheck)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error == nil {
                self.showChecked?.checkingReturn(b: true)
                SettingOnMap.shared.currentuserID = Auth.auth().currentUser?.uid ?? ""
                return
            }
            else{
                self.showChecked?.checkingReturn(b: false)
            }
           
        }
        
    }
    
    
}




