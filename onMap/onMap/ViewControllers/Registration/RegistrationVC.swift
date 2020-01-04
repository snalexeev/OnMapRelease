//

import UIKit
import Firebase

class AuthViewController: UIViewController {
    
    @IBOutlet weak var enterButton: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var usersurname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var useremail: UITextField!
    @IBOutlet weak var userpassword: UITextField!
    @IBOutlet weak var userrepeatspassword: UITextField!
    
   
//    var signup: Bool = true{
//        willSet{
//            if newValue{
//                titleLabel.text = "Регистрация"
//                username.isHidden = false
//                enterButton.setTitle("зарегистрироваться!", for: .normal)
//
//            }
//            else{
//                titleLabel.text = "Вход"
//                username.isHidden = true
//                enterButton.setTitle("войти", for: .normal)
//
//
//            }
//        }
//    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        username.delegate = self
        usersurname.delegate = self
        useremail.delegate = self
        userpassword.delegate = self
        userrepeatspassword.delegate = self
        
        
        let hideKeyboardGesture =  UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        //подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    @objc func hideKeyboard(){
        scrollView.endEditing(true)
    }
    
    @objc func keyboardWasShown(notification: Notification){
        //получаем размер клавиатуры
        let info  = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey)as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        //добавляем отступ внизу uiscrollview, равный размеру клавиатуры
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification){
        //устанавливаем отступ внизу UIScrollView
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    
    func sign_Up(){
        let ussurname = usersurname.text!
        let usname  = username.text!
        let usem = useremail.text!
        let uspas = userpassword.text!
        let reppas = userrepeatspassword.text!
        NetworkingService.shared.showAlertDelegate = self
        //NetworkingService.shared.signUpUser(name: usname, surname: ussurname, email: usem, password: uspas, reppassword: reppas)
        
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        sign_Up()
        
    }
    
    @IBAction func backToLogin(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension AuthViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if (textField.returnKeyType == UIReturnKeyType.next){
            let nextTage=textField.tag+1;
            let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
            if (nextResponder != nil){
                nextResponder?.becomeFirstResponder()
            }
            else{
                textField.resignFirstResponder()
            }
            return true
        }
            
        else{
            sign_Up()
            return true
        }
    }
    
}
extension AuthViewController: ShowAlertDelegate{
    func showNext(from: Int) {
        let storyboard = UIStoryboard(name: "PhotoSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PickUpPhotoController") as! PickUpPhotoController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showAlert(title: String, message: String)  {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}


