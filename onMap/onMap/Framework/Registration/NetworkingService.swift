//

import Foundation
import UIKit
import Firebase
protocol PhoneCheckDelegate{
    func checkingReturn(b: Bool)
    func sendCodeReturn(b: Bool)
}
protocol ShowAlertDelegate {
    func showAlert(title: String, message: String)
    func showNext(from: Int)
}
protocol ReAuthDelegate{
    func reAuthDelegate()
}
class NetworkingService{
    private init() {}
    public static let shared = NetworkingService()
    var showAlertDelegate: ShowAlertDelegate?
    var showChecked: PhoneCheckDelegate?
    var reAuthDelegate: ReAuthDelegate?
    var user: User = User()
    var title: String = ""
    var message: String = ""
    let success: String = "Success"
    func reauth(codeForCheck: String){
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "0"
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: codeForCheck)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
            if error != nil{
                self.showAlertDelegate?.showAlert(title: "Ошибка", message: error.debugDescription)
            }
            else{
                self.showChecked?.checkingReturn(b: true)
            }
        })
    }
    func updatePhone(codeForCheck: String){
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "0"
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: codeForCheck)
        Auth.auth().currentUser?.updatePhoneNumber(credential, completion: { (error) in
            if error != nil{
                self.showAlertDelegate?.showAlert(title: "Ошибка", message: error.debugDescription)
            }
            else{
                self.showChecked?.checkingReturn(b: true)
                self.reAuthDelegate?.reAuthDelegate()
            }
        })
    }
    
    func updateEmail(email: String){
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
            if error == nil{
                self.showAlertDelegate?.showNext(from: 0)
                self.reAuthDelegate?.reAuthDelegate()
            }
            else{
                self.showAlertDelegate?.showAlert(title: "Ошибка", message: error?.localizedDescription ?? "")
            }
        })
        
    }
    func addInformation(name: String, surname: String, status: String){
        title = success
        message = success
        if (name.isEmpty || surname.isEmpty){
            title = "Ошибка"; message = "Заполните все поля"
            self.showAlertDelegate?.showAlert(title: self.title, message: self.message)
            return
        }
        user.name = name
        user.surname = surname
        let date = Date().description
        let refToDataBase = Database.database().reference().child("users")
        refToDataBase.child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["name": self.user.name, "email": self.user.email, "surname": self.user.surname, "status": status, "date": date])
       // let myTopPostsQuery = (refToDataBase.child("nickname").child(Auth.auth().currentUser?.uid ?? "")).queryEqual(toValue: nickname)

        
    }
    
    func linkEmail(email: String, password: String, reppassword: String){
        title = success
        message = success
        if reppassword != password{
            title = "Ошибка"; message = "Пароли не совпадают"
            self.showAlertDelegate?.showAlert(title: self.title, message: self.message)
            return
        }
        user.email = email
        user.password = password
        let credential = EmailAuthProvider.credential(withEmail: user.email, password: user.password)
        Auth.auth().currentUser?.link(with: credential, completion: { (result, error) in
            if error == nil{
                if let result = result{
                    self.showAlertDelegate?.showNext(from: 1)
                    SettingOnMap.shared.currentuserID = Auth.auth().currentUser?.uid ?? ""
                }
            }
            else{
                self.message = String(error!.localizedDescription)
                self.title = "Ошибка"
                self.showAlertDelegate?.showAlert(title: self.title, message: self.message)
            }
        })
        
    }
    func sendCode(text: String){
        let phoneNumber  = text
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) {  (verificationID, error) in
            if error == nil{
                UserDefaults.standard.removeObject(forKey: "authVerificationID")
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                 self.showChecked?.sendCodeReturn(b: true)
                
            }
            else{
                self.showChecked?.sendCodeReturn(b: false)
            }
        }
    }
    func check(codeForCheck: String){
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? "0"
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: codeForCheck)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error == nil {
                if Auth.auth().currentUser?.email != nil{
                    SettingOnMap.shared.currentuserID = authResult?.user.uid ?? ""
                    self.showChecked?.checkingReturn(b: true)
                }
                else{
                    self.showChecked?.checkingReturn(b: true)
                }

                return
            }
            else{
                self.showChecked?.checkingReturn(b: false)
            }
           
        }
        
    }
    
    
}




