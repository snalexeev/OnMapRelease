//


import UIKit
import Firebase
class PhoneAuthVC1: UIViewController {
    var vc: AuthViewController = AuthViewController()
    var checked: Bool = false{
        willSet{
            if newValue{
                checkCode.isHidden = true
                checkCode.isEnabled = false
                contReg.isHidden = false
                contReg.isEnabled = true
            }
        }
    }
    var sendCodeBool: Bool = false{
        willSet{
            if newValue{
                sendCodeButton.isHidden = true
                code.isHidden = false
                sendCodeButton.isEnabled = false
                code.isEnabled = true
                checkCode.isEnabled = true
                checkCode.isHidden = false
            }
            
        }
    }
    
    @IBOutlet weak var checkCode: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var phone: UITextField!
    
    @IBOutlet weak var sendCodeButton: UIButton!
    
    @IBOutlet weak var code: UITextField!
    
    @IBOutlet weak var contReg: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCodeButton.layer.cornerRadius = 7
        contReg.layer.cornerRadius = 7
        code.isHidden = true
        contReg.isHidden = true
        code.isEnabled = false
        contReg.isEnabled = false
        checkCode.layer.cornerRadius = 7
        checkCode.isHidden = true
        checkCode.isEnabled = false
        phone.text! = ""
        code.text! = ""
        let hideKeyboardGesture =  UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        //подписываемся на два уведомления: одно приходит при появлении клавиатуры, другое перед скрыванием
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    
    @IBAction func sendCode(_ sender: Any) {
        sendCodeBool = true
        NetworkingService.shared.sendCode(text: phone.text!)
    }
    
    @IBAction func checkcodeButton(_ sender: Any) {
        NetworkingService.shared.showChecked = self
        NetworkingService.shared.check(codeForCheck: code.text!)
        
    }
    
    @IBAction func continueRegistration(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RegistrationSB", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as! AuthViewController
        navigationController?.pushViewController(vc, animated: true)
        //phone.text! = ""
        //code.text! = ""
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
    
    @objc func hideKeyboard(){
        scrollView.endEditing(true)
    }
  

}
extension PhoneAuthVC1: PhoneCheckDelegate{
    func sendCodeReturn(b: Bool) {
        
    }
    
    func checkingReturn(b: Bool) {
        checked = b
        if !checked{
            let alert = UIAlertController(title: "Неверный код", message: "Попробуйте ввести ещё раз", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
}
