//


import UIKit
import Firebase
final class LoginViewController: UIViewController {
    //var vc: AuthViewController = AuthViewController()
    var vc: PhoneAuthVC = PhoneAuthVC()
    var checked: Bool = false{
        willSet{
            if newValue{
                enterButton.isEnabled = true
                enterButton.isHidden = false
            }
        }
        
    }
    var sendCodeBool: Bool = false{
        willSet{
            if newValue{
                senfCodeButton.isHidden = true
                senfCodeButton.isEnabled = false
                codeField.isHidden = false
                codeField.isEnabled = true
            }
        }
    }
    var wayOfSignIn = false{
        willSet{
            if newValue == true{
                senfCodeButton.isHidden = false
                senfCodeButton.isEnabled = true
                login.placeholder = "Номер телефона"
                password.isHidden = true
                password.isEnabled = false
                enterButton.isHidden = true
                enterButton.isEnabled = false
                login.text! = ""
                password.text! = ""
                codeField.text! = ""
            }
            else{
                codeField.isHidden = true
                codeField.isEnabled = false
                senfCodeButton.isHidden = true
                senfCodeButton.isEnabled = false
                login.placeholder = "Email"
                password.isHidden = false
                password.isEnabled = true
                enterButton.isEnabled = true
                enterButton.isHidden = false
                login.text! = ""
                password.text! = ""
                codeField.text! = ""
                
            }
        }
    }
    @IBOutlet weak var second: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var codeField: UITextField!
    @IBOutlet weak var senfCodeButton: UIButton!
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
         Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil{
                self.presentMapVC()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        codeField.isHidden = true
        codeField.isEnabled = false
        senfCodeButton.isHidden = true
        senfCodeButton.isEnabled = false
        login.placeholder = "Email"
        codeField.delegate = self
        login.text! = ""
        password.text! = ""
        codeField.text! = ""
        
        //делегаты
        login.delegate = self
        password.delegate = self
        codeField.delegate = self
        LoginNetworking.shared.loginDelegate = self as? LoginDelegate

        
        let hideKeyboardGesture =  UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        
        //подписываемся на два уведомления: одно приходит при появлении клавиатуры, другое перед скрыванием
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    func presentMapVC(){
        let theUsername = "testUser"
        let storyboard = UIStoryboard.init(name: "MapViewController", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
               newViewController.modalPresentationStyle = .fullScreen
               newViewController.textUsername = theUsername
        let navC = UINavigationController.init(rootViewController: newViewController)
        navC.modalPresentationStyle = .fullScreen
        present(navC, animated: true, completion: nil)
        
//        self.beginAppearanceTransition(false, animated: true)
//        navC.beginAppearanceTransition(true, animated: true)
//        UIView.transition(from: self.view, to: navC.view, duration: 0.5, options: [.transitionCrossDissolve]) { (_) in
//            UIApplication.shared.delegate?.window??.rootViewController = navC
//        }
//        self.endAppearanceTransition()
//        navC.endAppearanceTransition()
    }
//    var isFlipped = true
//    func flip(){
//        isFlipped = !isFlipped
//        let fromview = isFlipped ? second : scrollView
//        let toview = isFlipped ? scrollView : second
//        UIView.transition(from: fromview!, to: toview!, duration: 0.4, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.transitionFlipFromLeft,UIView.AnimationOptions.showHideTransitionViews])
//
//    }
    @IBAction func signUpButtonPressed(_ sender: Any) {
         showRegistration()
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ResetPasswordSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        self.present(vc, animated: true, completion: nil)
        
        
    }
    func showRegistration(){
        let storyboard = UIStoryboard(name: "PhoneAuthSB", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "PhoneAuthVC") as! PhoneAuthVC
        let nc = UINavigationController.init(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
        
    }

    @IBAction func indexChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            wayOfSignIn = false
        case 1:
            wayOfSignIn = true
        default:
            break
        }
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        logIn()
    }
    func logIn(){
        if wayOfSignIn == false{
            if (!login.text!.isEmpty && !password.text!.isEmpty){
                LoginNetworking.shared.login(email: login.text!, password:password.text!)
            }
        }
        else{
            LoginNetworking.shared.checkUser()
        }
    }
    
    @IBAction func sendCode(_ sender: Any) {
        sendCodeBool = true
        NetworkingService.shared.sendCode(text: login.text!)
    }
    
    //override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
    
    //клавиатура
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
extension LoginViewController: LoginDelegate{
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loginCompleted() {
        self.hideKeyboard()
        self.presentMapVC()
    }
    
    func ifUserExists() {
        hideKeyboard()
        self.presentMapVC()
    }
    
    
}

extension LoginViewController: ShowCheckedDelegate{
    func checkingReturn(b: Bool) {
        checked = b
        if !checked{
            let alert = UIAlertController(title: "Неверный код", message: "Попробуйте ввести ещё раз", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        print(b)
    }
    
}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.send){
            NetworkingService.shared.showChecked = self
            NetworkingService.shared.check(codeForCheck: codeField.text!)
        }

        if (textField.returnKeyType == UIReturnKeyType.next){
            let nextTage=textField.tag+1;
            let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
            if (nextResponder != nil){
                nextResponder?.becomeFirstResponder()
            }
            else{
                textField.resignFirstResponder()
            }
        }
        if (textField.returnKeyType == UIReturnKeyType.go){
            logIn()
        }
        return true
    }
    
}
