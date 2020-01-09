
import Foundation
import Firebase
import UIKit
protocol AccountDelegate {
    func setFields(name: String, surname: String, phone: String, email: String, status: String)
    func setImage(image: UIImage?)
    func showError(title: String, message: String, status: Bool)
}
protocol AccountDelegateForConfirmation {
    func showErrorWithConfirmation(error: String)
    func dismissConfirmation()
}

class Account{
    private init() {}
    public static let shared = Account()
    var accountDelegate: AccountDelegate?
    var accountDelegateForConfirmation: AccountDelegateForConfirmation?
    private var name: String = ""
    private var surname: String = ""
    private var phone: String = ""
    private var email: String = ""
    private var id: String = ""
    private var image: UIImage?
    private var status: String = ""
    var ref: DatabaseReference!
    var storeRef: StorageReference!

    func loadData(){
        let userID = SettingOnMap.shared.currentuserID
        storeRef = Storage.storage().reference().child("images/profiles/" + String(userID)+".png")
            
        storeRef.getData(maxSize: 16 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error \(error)")
          } else {
            self.image = UIImage(data: data!)!
            self.accountDelegate?.setImage(image: self.image)
          }
        }
        self.id = userID
        ref = Database.database().reference()
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            self.name = value?["name"] as? String ?? ""
            self.surname = value?["surname"] as? String ?? ""
            self.status =  value?["status"] as? String ?? ""
            self.phone =  Auth.auth().currentUser?.phoneNumber ?? ""
            self.email = Auth.auth().currentUser?.email ?? ""
            
            self.accountDelegate?.setFields(name: self.name, surname: self.surname, phone: self.phone, email: self.email, status: self.status)
          }) { (error) in
            //print(error.localizedDescription)
        }
    }
    func loadTextDataByID(userID: String, completion: @escaping ((_ name: String, _ surname: String)->Void)){
        //let storeRef = Storage.storage().reference().child("images/profiles/\(userID).png")
        var name = ""
        var surname = ""
        ref = Database.database().reference()
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            name = value?["name"] as? String ?? ""
            surname = value?["surname"] as? String ?? ""
            completion(name, surname)
          }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func loadPhotoByID(userID: String, completion: @escaping ((_ photo: UIImage)->Void)){
        storeRef = Storage.storage().reference().child("images/profiles/" + String(id)+".png")
        storeRef.getData(maxSize: 16 * 1024 * 1024) { data, error in
          if let error = error {
            print("Error \(error)")
          } else {
            completion(UIImage(data: data!)!)
          }
        }
    }
    func getID()->String{
        return self.id
    }
    func getName()->String{
        return self.name
    }
    func getSurname()->String{
        return self.surname
    }
    func getStatus()->String{
        return self.status
    }
    func getPhone()->String{
        return self.phone
    }
    func getEmail()->String{
        return self.email
    }
    
    func getPhoto()->UIImage?{
        return self.image
    }
    
    func setUserName(name: String){
        ref = Database.database().reference().child("users")
        ref.child(id).updateChildValues(["name": name])
        self.name = name
    }
    
    func setUserSurname(surname: String){
        ref = Database.database().reference().child("users")
        ref.child(id).updateChildValues(["surname": surname])
        self.surname = surname
    }
    func setUserStatus(status: String){
        ref = Database.database().reference().child("users")
        ref.child(id).updateChildValues(["status": status])
        self.status = status
    }
    func setPhone(phone: String){
        //NetworkingService.shared.sendCode(text: phone)
    }
    
    
    func deleteAccount(password: String){
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
                self.accountDelegateForConfirmation?.dismissConfirmation()
                let user = Auth.auth().currentUser
                user?.delete { error in
                  if let error = error {
                    self.accountDelegate?.showError(title: "Ошибка", message: error.localizedDescription, status: false)
                  } else {
                    self.ref = Database.database().reference().child("users").child(self.id)
                    self.ref.removeValue()
                    self.storeRef = Storage.storage().reference().child("images/profiles/" + String(user?.uid ?? "")+".png")
                    self.accountDelegate?.showError(title: "Успех!", message: "Аккаунт удалён", status: true)
                    SettingOnMap.shared.currentuserID = ""
                  }
                }
            }
            else{
                self.accountDelegateForConfirmation?.showErrorWithConfirmation(error: error?.localizedDescription ?? "неверный пароль")
            }
        }
    
        
        
    }
    
    
}
