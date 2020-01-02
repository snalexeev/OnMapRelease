//
//  PhoneAuthViewContoller.swift
//  onMap
//
//  Created by Екатерина on 02/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import UIKit

class PhoneAuthViewContoller: UIViewController {
    var wayOfSignIn: Bool = false

    private let logoText = UILabel()
    private var customViews: Array<Custom> = []
    private var gradient = Gradient()
    private var activityIndicator = UIActivityIndicatorView()
    
    
    private var openPhoneLoginView = UIButton()
    private var tip1OnPhoneCustomView = UILabel()
    private var tip2OnPhoneCustomView = UILabel()
    private var phoneCustomViewTextField = UITextField()
    private var tipTimerPhoneCustomView = UILabel()
    private var nextPhoneCustomViewButton = UIButton()
    private var backPhoneCustomViewButton = UIButton()
    private var startBorder: Int = 0
    private var endBorder: Int = 0
    let closeEditing = UIButton()
    
    
    private var openEmailLoginView = UIButton()
    private var tip1OnEmailLoginView = UILabel()
    private var tip2OnEmailLoginView = UILabel()
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var nextEmailButton = UIButton()
    private var backEmailButton = UIButton()
    private var repeatedPasswordTextField = UITextField()
    
    private var pickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingService.shared.showChecked = self
        NetworkingService.shared.showAlertDelegate = self
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.frame = CGRect(x: view.bounds.width/2-view.bounds.width/6, y: view.bounds.height/2-view.bounds.width/6, width: view.bounds.width/3, height: view.bounds.width/3)
        activityIndicator.color = UIColor.gray
        

        
        view.addSubview(gradient)
        gradient.frame = view.frame
        //setting up start point of logo
        logoText.setUpLabel(text: "ONMAP", color:  Const.themeColor, textSize: view.bounds.width/6, y: view.bounds.width/3)
        //setting up start points of rects
        for i in 0...2{
            setUpCustomView(index: i)
        }
        
        customViews[1].animateUp(delta: view.bounds.height/1.4-view.bounds.width, delay: 0, duration: 0.25)
        customViews[0].animateDown(delta: view.bounds.width, delay: 0, duration: 0)
        customViews[2].animateDown(delta: view.bounds.width, delay: 0, duration: 0)
        logoText.alpha = 0
        view.addSubview(logoText)
        let scaleDuration: TimeInterval = 0.9
        let delay: TimeInterval = 0.25
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: scaleDuration, animations: {
                self.logoText.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.logoText.alpha = 1
            }, completion: nil)
        }
        fillLoginWithPhoneCustomView()
        openPhoneView()
        fillLoginWithEmailCustomView()

    }
   
 
     //заполняет view кастомными
     func setUpCustomView(index: Int){
         let customView = Custom()
         customViews.append(customView)
         customViews[index].backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
         customViews[index].frame = view.frame
         //adding to root view
         view.addSubview(customViews[index])
     }
    
     

     func doActionsToCloseLogin(){
         if wayOfSignIn==false{
             customViews[2].animateDown(delta: view.bounds.height/1.4, delay: 0, duration: 0.2)
         }
         else{
             customViews[1].animateDown(delta: view.bounds.height/1.4, delay: 0, duration: 0.2)
         }
     }
     
    
    //ЛОГИН ПО EMAIL
    //открывает логин по email
    @objc
    private func openEmailView(){
        wayOfSignIn = false
        setupEmailLoginView()
        view.bringSubviewToFront(customViews[2])
        customViews[2].animateUp(delta: view.bounds.height/1.4, delay: 0, duration: 0.22)
    }
    func fillLoginWithEmailCustomView(){
        setupEmailLoginView()
        customViews[2].addSubview(repeatedPasswordTextField)
        customViews[2].addSubview(tip1OnEmailLoginView)
        customViews[2].addSubview(tip2OnEmailLoginView)
        customViews[2].addSubview(emailTextField)
        customViews[2].addSubview(passwordTextField)
        customViews[2].addSubview(nextEmailButton)
        emailTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action:
            #selector(editingChanged(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        //backEmailButton.addTarget(self, action:  #selector(disappearReset), for: .touchUpInside)
        nextEmailButton.addTarget(self, action:  #selector(linkWithCredential), for: .touchUpInside)
        repeatedPasswordTextField.addTarget(self, action:
            #selector(editingChanged(_:)), for: .editingChanged)
        repeatedPasswordTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        
    }
    @objc func disappearFirstEmail(){
        setupResetView()
        //customViews[2].addSubview(backEmailButton)
        nextEmailButton.removeTarget(self, action:  #selector(linkWithCredential), for: .touchUpInside)
        
    }

    
    func setupEmailLoginView(){
        startBorder = 1
        endBorder = 40
        tip1OnEmailLoginView.setUpLabel(text: "Please, enter your", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 8.5/14*self.view.bounds.height)
        tip2OnEmailLoginView.setUpLabel(text: "Email and password", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 9/14*self.view.bounds.height)
        
        emailTextField.setUpAnyTextField(width: self.view.bounds.width/1.8, height: UIScreen.main.bounds.height/18, textSize: self.view.bounds.width/35, colorText: Const.gray, colorBack: Const.grayAlpha, y: 9.8/14*self.view.bounds.height, placeholder: "first name", strokeColor: Const.gray)
        
        passwordTextField.isSecureTextEntry = false
        passwordTextField.setUpAnyTextField(width: self.view.bounds.width/1.8, height: UIScreen.main.bounds.height/18, textSize: self.view.bounds.width/35, colorText: Const.gray, colorBack: Const.grayAlpha, y: 10.8/14*self.view.bounds.height, placeholder: "second name", strokeColor: Const.gray)
        
       repeatedPasswordTextField.isSecureTextEntry = false
       repeatedPasswordTextField.setUpAnyTextField(width: self.view.bounds.width/1.8, height: UIScreen.main.bounds.height/18, textSize: self.view.bounds.width/35, colorText: Const.gray, colorBack: Const.grayAlpha, y: 11.8/14*self.view.bounds.height, placeholder: "", strokeColor: Const.gray)
        
        nextEmailButton.setUpButton(text: "next", colorText: Const.themeColor, colorBack: Const.green, textSize: customViews[1].bounds.width/17, y: 12.9/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20)
    }
    func setupResetView(){
        tip1OnEmailLoginView.setUpLabel(text: "Give us additional", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 8.5/14*self.view.bounds.height)
        tip2OnEmailLoginView.setUpLabel(text: "info about yourself", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 9/14*self.view.bounds.height)
        nextEmailButton.setUpButtonWithX(text: "next", colorText: Const.themeColor, colorBack: Const.green, x: 4.6*view.bounds.width/9, textSize: customViews[1].bounds.width/17, y: 11/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20, borderColor: Const.greenCG, borderWidth: 0)
        //backEmailButton.setUpButtonWithX(text: "back", colorText: Const.green, colorBack: Const.themeColor, x: 1.4*view.bounds.width/9, textSize: customViews[1].bounds.width/17, y: 11/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20, borderColor: Const.greenCG, borderWidth: 1)
        
    }
    
    
    //ЛОГИН ПО ТЕЛЕФОНУ
    //открывает логин по телефону
    @objc
    private func openPhoneView(){
        wayOfSignIn = true
        disappearSecondPhone()
        view.bringSubviewToFront(customViews[1])
    }
    //наполняет первое окно логина по телефону объектами
    func fillLoginWithPhoneCustomView(){
        setupFirstPhoneView()
        customViews[1].addSubview(phoneCustomViewTextField)
        customViews[1].addSubview(tip1OnPhoneCustomView)
        customViews[1].addSubview(nextPhoneCustomViewButton)
        phoneCustomViewTextField.addTarget(self, action: #selector(editingChangedPhone(_:)), for: .editingChanged)
        phoneCustomViewTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        
        nextPhoneCustomViewButton.addTarget(self, action: #selector(decideToOpenSecondPhone), for: .touchUpInside)
    }
    
    //заполняет характеристики первого окна для логина по телефону
    func setupFirstPhoneView(){
        tip1OnPhoneCustomView.setUpLabel(text: "Please, tell us your phone", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 8.5/14*self.view.bounds.height)
        
        phoneCustomViewTextField.setUpPhoneTextField(width: self.view.bounds.width/1.8, height: UIScreen.main.bounds.height/18, textSize: self.view.bounds.width/35, colorText: Const.gray, colorBack: Const.grayAlpha, y: 9.3/14*self.view.bounds.height)
        
        nextPhoneCustomViewButton.setUpButton(text: "next", colorText: Const.themeColor, colorBack: Const.green, textSize: customViews[1].bounds.width/17, y: 10.5/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20)
    }
    //заполняет характеристики второго окна для логина по телефону
    func setupSecondPhoneView(){
        tip1OnPhoneCustomView.setUpLabel(text: "We just sent to you a code.", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 8.5/14*self.view.bounds.height)
        tip2OnPhoneCustomView.setUpLabel(text: "Usually arrives fast...", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 9.2/14*self.view.bounds.height)
        phoneCustomViewTextField.setUpAnyTextField(width: self.view.bounds.width/1.8, height: UIScreen.main.bounds.height/18, textSize: self.view.bounds.width/35, colorText: Const.gray, colorBack: Const.grayAlpha, y: 10/14*self.view.bounds.height, placeholder: "Insert 6-digit code", strokeColor: Const.themeColor)
        nextPhoneCustomViewButton.setUpButtonWithX(text: "next", colorText: Const.themeColor, colorBack: Const.green, x: 5*view.bounds.width/9, textSize: customViews[1].bounds.width/17, y: 11.5/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20, borderColor: Const.greenCG, borderWidth: 0)
        backPhoneCustomViewButton.setUpButtonWithX(text: "back", colorText: Const.green, colorBack: Const.themeColor, x: view.bounds.width/9, textSize: customViews[1].bounds.width/17, y: 11.5/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20, borderColor: Const.greenCG, borderWidth: 1)
    }
    @objc func decideToOpenSecondPhone(){
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.sendCodeNet(phone: self.phoneCustomViewTextField.getRealPhone(phone: self.phoneCustomViewTextField.text ?? ""))
        }
    }
    @objc func decideToOpenApp(){
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        DispatchQueue.main.async {
            self.checkCode()
        }
    }
    
    //действия с интерфейсом при возвращении со второго окна на первое
    @objc func disappearFirstPhone(){
        setupSecondPhoneView()
        customViews[1].addSubview(tip2OnPhoneCustomView)
        startBorder = 6
        endBorder = 6
        phoneCustomViewTextField.removeTarget(self, action: #selector(editingChangedPhone(_:)), for: .editingChanged)
        phoneCustomViewTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        
        backPhoneCustomViewButton.addTarget(self, action: #selector(disappearSecondPhone), for: .touchUpInside)
        customViews[1].addSubview(backPhoneCustomViewButton)
        nextPhoneCustomViewButton.removeTarget(self, action: #selector(decideToOpenSecondPhone), for: .touchUpInside)
        nextPhoneCustomViewButton.addTarget(self, action: #selector(decideToOpenApp), for: .touchUpInside)
        
    }
    //действия с интерфейсом при переходе с первого окна на второе
    @objc func disappearSecondPhone(){
        setupFirstPhoneView()
        tip2OnPhoneCustomView.removeFromSuperview()
        phoneCustomViewTextField.removeTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        phoneCustomViewTextField.addTarget(self, action: #selector(editingChangedPhone(_:)), for: .editingChanged)
        backPhoneCustomViewButton.removeTarget(self, action: #selector(disappearSecondPhone), for: .touchUpInside)
        backPhoneCustomViewButton.removeFromSuperview()
        nextPhoneCustomViewButton.removeTarget(self, action: #selector(decideToOpenApp), for: .touchUpInside)
        nextPhoneCustomViewButton.addTarget(self, action: #selector(decideToOpenSecondPhone), for: .touchUpInside)
        
    }
    
    //обработка закрытия клавиатуры
    @objc func editingDidBegin(_ textField: UITextField) {
        closeEditing.setUpButton(text: "", colorText: UIColor(red: 0, green: 0, blue: 0, alpha: 0), colorBack: UIColor(red: 0, green: 0, blue: 0, alpha: 0), textSize: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        closeEditing.addTarget(self, action: #selector(closeEditingAction(_:)), for: .touchUpInside)
        //view.bringSubviewToFront(closeEditing)
        view.addSubview(closeEditing)
    }
    @objc func closeEditingAction(_ textField: UITextField){
        closeEditing.removeFromSuperview()
        view.endEditing(true)
    }
    
    //обработка редактирования textField для кода
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count ?? 0 >= startBorder && textField.text?.count ?? 0 <= endBorder{
            textField.layer.borderWidth = 1
            textField.layer.borderColor = .init(srgbRed: 42/255, green: 0, blue: 178/255, alpha: 1)
        }
        else{
            textField.layer.borderWidth = 0
        }
    }
    
    //обработка редактирования textField для телефона
    @objc func editingChangedPhone(_ textField: UITextField) {
        if textField.text != ""{
            textField.text = textField.workWithPhone(phone: textField.text ?? "+")
        }
        else{
            textField.text = "+"
        }
        if textField.text?.count == 18{
            textField.layer.borderWidth = 1
            textField.layer.borderColor = CGColor(srgbRed: 42/255, green: 0, blue: 178/255, alpha: 1)
        }
        else{
            textField.layer.borderWidth = 0
        }
    }
    func sendCodeNet(phone: String){
        print(phone)
        if phone != ""{
            NetworkingService.shared.sendCode(text: phone)
        }
        else{
            showAlert(title: "Ошибка", message: "Введите номер телефона")
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            //disappearFirstPhone()
        }
    }
    @objc func checkCode(){
        let code = phoneCustomViewTextField.text
        if code != nil{
            NetworkingService.shared.showChecked = self
            NetworkingService.shared.check(codeForCheck: code ?? "")
        }
        else{
            showAlert(title: "Ошибка", message: "Введите код из SMS")
        }
        
    }
    func showAlertOnVC(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    //все переходы
 
    @objc func linkWithCredential(){
        if (emailTextField.text == nil || passwordTextField.text == nil || repeatedPasswordTextField.text == nil){
            showAlert(title: "Ошибка", message: "Заполните все поля")

        }
        else{
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            DispatchQueue.main.async {
                NetworkingService.shared.linkEmail(email: self.emailTextField.text!, password: self.passwordTextField.text!, reppassword: self.repeatedPasswordTextField.text!)
            }
            
        }
        
    }
}
  


extension PhoneAuthViewContoller: PhoneCheckDelegate{
    func sendCodeReturn(b: Bool) {
        print("here")
        if !b{
            showAlert(title: "Неверный номер телефона", message: "Попробуйте ввести ещё раз")
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        else{
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            disappearFirstPhone()

        }
    }
    
    func checkingReturn(b: Bool) {
        if !b{
            showAlert(title: "Неверный код", message: "Попробуйте ввести ещё раз")
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        else{
            self.openEmailView()
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
    }
    
}
extension PhoneAuthViewContoller: ShowAlertDelegate{
    func showNext() {
       var k = 5
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    func showAlert(title: String, message: String){
        self.showAlertOnVC(title: title, message: message)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    
}
