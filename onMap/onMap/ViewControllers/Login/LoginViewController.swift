//
//  LoginViewController.swift
//  onMap
//
//  Created by Екатерина on 28/12/2019.
//  Copyright © 2019 onMap. All rights reserved.
//
import UIKit
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
        LoginNetworking.shared.loginDelegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let hideKeyboardGesture =  UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(hideKeyboardGesture)
        
        //подписываемся на два уведомления: одно приходит при появлении клавиатуры, другое перед скрыванием
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
   
    @IBAction func signUpButtonPressed(_ sender: Any) {
        showRegistration()
    }
    @IBAction func loginButtonPressed(_ sender: Any) {
        logIn()
    }
    @IBAction func forgotPassword(_ sender: Any) {
        showReset()
    }
    @IBAction func sendCode(_ sender: Any) {
        sendCodeBool = true
        sendCodeNet()
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
    
//все переходы
    func showReset(){
        let storyboard = UIStoryboard(name: "ResetPasswordSB", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        self.present(vc, animated: true, completion: nil)
    }
    func showMainTabBar() {
        let vc1 = UIStoryboard(name: "AccountViewController", bundle: nil).instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        let nc1 = UINavigationController.init(rootViewController: vc1)
        let vc2 = UIStoryboard(name: "MapViewController", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let nc2 = UINavigationController.init(rootViewController: vc2)
        let vc3 = UIStoryboard(name: "SettingsViewController", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        let nc3 = UINavigationController.init(rootViewController: vc3)
        let tb = UITabBarController()
        tb.setViewControllers([nc1, nc2, nc3], animated: true)
        tb.selectedIndex = 1
        
        tb.modalPresentationStyle = .fullScreen
        present(tb, animated: false)
    }

    func showRegistration(){
        let storyboard = UIStoryboard(name: "PhoneAuthSB", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "PhoneAuthVC") as! PhoneAuthVC
        let nc = UINavigationController.init(rootViewController: vc)
        nc.modalPresentationStyle = .fullScreen
        present(nc, animated: true)
    }


    func logIn(){
        if wayOfSignIn == false{
            if (!login.text!.isEmpty && !password.text!.isEmpty){
                LoginNetworking.shared.login(email: login.text!, password:password.text!)
            }
            else{
                showAlert(title: "Ошибка", message: "Заполните все поля")
            }
        }
        else{
            sendCodeNet()
        }
    }
    
    
    func sendCodeNet(){
        if login.text != nil{
            NetworkingService.shared.sendCode(text: login.text!)
        }
        else{
            showAlert(title: "Ошибка", message: "Введите номер телефона")
        }
    }
   
    func checkCode(){
        if codeField.text != nil{
            NetworkingService.shared.showChecked = self
            NetworkingService.shared.check(codeForCheck: codeField.text!)
        }
        else{
            showAlert(title: "Ошибка", message: "Введите код из SMS")
        }
        
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func loginSucceeded(){
        self.hideKeyboard()
        self.showMainTabBar()
        DispatchQueue.main.async {
            Account.shared.loadData()
        }
    }
    
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
    func showAlertWithError(title: String, message: String) {
        showAlert(title: title, message: message)
    }
    func loginCompleted() {
        self.loginSucceeded()
    }
}

extension LoginViewController: PhoneCheckDelegate{
    func checkingReturn(b: Bool) {
        checked = b
        if !checked{
            showAlert(title: "Неверный код", message: "Попробуйте ввести ещё раз")
        }
        else{
            loginSucceeded()
        }
        
    }
    
}
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.returnKeyType == UIReturnKeyType.send){
            self.checkCode()
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


//    func presentMapVC(){
//        let theUsername = "testUser"
//        let storyboard = UIStoryboard.init(name: "MapViewController", bundle: nil)
//        let newViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//               newViewController.modalPresentationStyle = .fullScreen
//               newViewController.textUsername = theUsername
//        let navC = UINavigationController.init(rootViewController: newViewController)
//        navC.modalPresentationStyle = .fullScreen
//        present(navC, animated: true, completion: nil)

//        self.beginAppearanceTransition(false, animated: true)
//        navC.beginAppearanceTransition(true, animated: true)
//        UIView.transition(from: self.view, to: navC.view, duration: 0.5, options: [.transitionCrossDissolve]) { (_) in
//            UIApplication.shared.delegate?.window??.rootViewController = navC
//        }
//        self.endAppearanceTransition()
//        navC.endAppearanceTransition()
//    }
//    var isFlipped = true
//    func flip(){
//        isFlipped = !isFlipped
//        let fromview = isFlipped ? second : scrollView
//        let toview = isFlipped ? scrollView : second
//        UIView.transition(from: fromview!, to: toview!, duration: 0.4, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.transitionFlipFromLeft,UIView.AnimationOptions.showHideTransitionViews])
//
//    }
