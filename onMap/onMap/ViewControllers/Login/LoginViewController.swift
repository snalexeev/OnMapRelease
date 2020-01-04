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
    var isFlipped = true
    var checked: Bool = false
    var sendCodeRet: Bool = false
    //private let logoImage = UIImageView()
    private let logoText = UILabel()
    private var customViews: Array<Custom> = []
    private var gradient = Gradient()
    private var activityIndicator = UIActivityIndicatorView()
    
    
    private var tipOnMainViewLabel = UILabel()
    private var areYouNewViewLabel = UILabel()
    private var openRegistrationButton = UIButton()
    private var openMainCustomViewButton = UIButton()
    private var wayOfSignIn: Bool = false
    
    private var openPhoneLoginView = UIButton()
    private var tip1OnPhoneCustomView = UILabel()
    private var tip2OnPhoneCustomView = UILabel()
    private var phoneCustomViewTextField = UITextField()
    private var tipTimerPhoneCustomView = UILabel()
    private var nextPhoneCustomViewButton = UIButton()
    private var backPhoneCustomViewButton = UIButton()
    private var startBorder: Int = 0
    private var endBorder: Int = 0
    //let closeEditing = UIButton()
    
    
    private var openEmailLoginView = UIButton()
    private var tip1OnEmailLoginView = UILabel()
    private var tip2OnEmailLoginView = UILabel()
    private var emailTextField = UITextField()
    private var passwordTextField = UITextField()
    private var resetButton = UIButton()
    private var nextEmailButton = UIButton()
    private var backEmailButton = UIButton()
    
    var vc: PhoneAuthViewContoller = PhoneAuthViewContoller()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        LoginNetworking.shared.loginDelegate = self
        NetworkingService.shared.showChecked = self
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.frame = CGRect(x: view.bounds.width/2-view.bounds.width/6, y: view.bounds.height/2-view.bounds.width/6, width: view.bounds.width/3, height: view.bounds.width/3)
        activityIndicator.color = UIColor.gray
        
        view.addSubview(gradient)
        gradient.frame = view.frame
        //setting up start point of logo
        logoText.alpha = 0
        logoText.setUpLabel(text: "ONMAP", color:  Const.themeColor, textSize: view.bounds.width/6, y: view.bounds.width/3)
        view.addSubview(logoText)
        //setting up start points of rects
        for i in 0...2{
            setUpCustomView(index: i, delta: view.bounds.height/2.2)

        }
        //animations with rects
        fillMainCustomView()
        fillLoginWithEmailCustomView()
        fillLoginWithPhoneCustomView()
        //customViews[0].animateUp(delta: view.bounds.height/3, delay: 0.5, duration: 0.2)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if !Const.didAppearLogin{
            Const.didAppearLogin = true
            customViews[0].animateUp(delta: view.bounds.height/2.2 -  view.bounds.height/14, delay: 1.1, duration: 0.25)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                UIView.animate(withDuration: 0.8) {
                    self.logoText.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.logoText.alpha = 1
                }
            }
        }
        
 
    }
    func isEnabledEverything(b: Bool){
        openPhoneLoginView.isEnabled = b
        openRegistrationButton.isEnabled = b
        openEmailLoginView.isEnabled = b
        openMainCustomViewButton.isEnabled = b
        nextPhoneCustomViewButton.isEnabled = b
        backPhoneCustomViewButton.isEnabled = b
        nextEmailButton.isEnabled = b
        backEmailButton.isEnabled = b
        resetButton.isEnabled = b
        emailTextField.isEnabled = b
        passwordTextField.isEnabled = b
        phoneCustomViewTextField.isEnabled = b
    }
   
    //заполняет view кастомными
    func setUpCustomView(index: Int, delta: CGFloat){
        let customView = Custom()
        customViews.append(customView)
        customViews[index].moveDown(delta: delta)
        customViews[index].backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        customViews[index].frame = view.frame
        //adding to root view
        view.addSubview(customViews[index])
    }
    
    //переключатель между способами входа
    func doActionsToCloseLogin(){
        if wayOfSignIn==false{
            customViews[2].animateDown(delta: view.bounds.height/1.4, delay: 0, duration: 0.2)
        }
        else{
            customViews[1].animateDown(delta: view.bounds.height/1.4, delay: 0, duration: 0.2)
        }
    }
    
    //переход на регистрацию
    @objc
    private func openRegistration(){
        print("reg")
        showRegistration()
    }
    
    
    //ГЛАВНОЕ ОКНО ЛОГИНА
    
    func setupMainCustomView(){
        let width = view.bounds.width/1.2
        let height = view.bounds.height/2.2
        openMainCustomViewButton.frame = CGRect(x: view.bounds.width / 2 - width/2, y: view.bounds.height - height, width: width, height: height)
        openMainCustomViewButton.layer.cornerRadius = UIScreen.main.bounds.width/8
        tipOnMainViewLabel.setUpLabel(text: "Login with", color: Const.gray, textSize: customViews[0].bounds.width/15, y: 8.5/14*self.view.bounds.height)
        openPhoneLoginView.setUpButton(text: "YOUR PHONE", colorText: Const.themeColor, colorBack: Const.green, textSize: self.view.bounds.width/18, y: 9.4/14*self.view.bounds.height, width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.width/15*2)
        openEmailLoginView.setUpButton(text: "EMAIL", colorText: Const.themeColor, colorBack: Const.mainBlueColor, textSize: self.view.bounds.width/18, y: 10.5/14*self.view.bounds.height, width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.width/15*2)
        areYouNewViewLabel.setUpLabel(text: "Are you new? ", color: Const.gray, textSize: customViews[0].bounds.width/30, y: 11.8/14*self.view.bounds.height)
        openRegistrationButton.setUpButton(text: "Start here", colorText: Const.green, colorBack: UIColor(red: 0, green: 0, blue: 0, alpha: 0), textSize: self.view.bounds.width/30, y: 12.1/14*self.view.bounds.height, width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/15)
    }
    //устанавливает все харатеристики главной страницы логина
    func fillMainCustomView(){
        view.bringSubviewToFront(customViews[0])
        setupMainCustomView()
        customViews[0].addSubview(openMainCustomViewButton)
        customViews[0].addSubview(tipOnMainViewLabel)
        customViews[0].addSubview(openPhoneLoginView)
        customViews[0].addSubview(openEmailLoginView)
        customViews[0].addSubview(areYouNewViewLabel)
        customViews[0].addSubview(openRegistrationButton)
        openPhoneLoginView.addTarget(self, action: #selector(openPhoneView), for: .touchUpInside)
        openEmailLoginView.addTarget(self, action: #selector(openEmailView), for: .touchUpInside)
        openRegistrationButton.addTarget(self, action: #selector(openRegistration), for: .touchUpInside)
    }
    
    
    func closeMainCustomView(){
        customViews[0].animateDown(delta: view.bounds.height/4.4, delay: 0, duration: 0.2)
        openMainCustomViewButton.addTarget(self, action: #selector(openMainCustomView), for: .touchUpInside)
        openPhoneLoginView.removeTarget(self, action: #selector(openPhoneView), for: .touchUpInside)
        openEmailLoginView.removeTarget(self, action: #selector(openEmailView), for: .touchUpInside)
        openRegistrationButton.removeTarget(self, action: #selector(openRegistration), for: .touchUpInside)
    }
    
    @objc
    private func openMainCustomView(){
        view.bringSubviewToFront(customViews[0])
        openMainCustomViewButton.removeTarget(self, action: #selector(openMainCustomView), for: .touchUpInside)
        customViews[0].animateUp(delta: view.bounds.height/4.4, delay: 0, duration: 0.22)
        openPhoneLoginView.addTarget(self, action: #selector(openPhoneView), for: .touchUpInside)
        openEmailLoginView.addTarget(self, action: #selector(openEmailView), for: .touchUpInside)
        openRegistrationButton.addTarget(self, action: #selector(openRegistration), for: .touchUpInside)
        doActionsToCloseLogin()
        
    }
    
    //ЛОГИН ПО EMAIL
    //открывает логин по email
    @objc
    private func openEmailView(){
        wayOfSignIn = false
        setupEmailLoginView()
        view.bringSubviewToFront(customViews[2])
        customViews[2].animateUp(delta: view.bounds.height/1.4, delay: 0, duration: 0.22)
        closeMainCustomView()
    }
    func fillLoginWithEmailCustomView(){
        setupEmailLoginView()
        customViews[2].addSubview(tip1OnEmailLoginView)
        customViews[2].addSubview(tip2OnEmailLoginView)
        customViews[2].addSubview(emailTextField)
        customViews[2].addSubview(passwordTextField)
        customViews[2].addSubview(nextEmailButton)
        customViews[2].addSubview(resetButton)
        emailTextField.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        //emailTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        passwordTextField.addTarget(self, action:
            #selector(editingChanged(_:)), for: .editingChanged)
        //passwordTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        resetButton.addTarget(self, action:  #selector(disappearFirstEmail), for: .touchUpInside)
        backEmailButton.addTarget(self, action:  #selector(disappearReset), for: .touchUpInside)
        nextEmailButton.addTarget(self, action:  #selector(logIn), for: .touchUpInside)
        
    }
    @objc func disappearFirstEmail(){
        setupResetView()
        passwordTextField.removeFromSuperview()
        customViews[2].addSubview(backEmailButton)
        resetButton.removeFromSuperview()
        nextEmailButton.removeTarget(self, action:  #selector(logIn), for: .touchUpInside)
        
    }
    @objc func disappearReset(){
        setupEmailLoginView()
        customViews[2].addSubview(passwordTextField)
        backEmailButton.removeFromSuperview()
        customViews[2].addSubview(resetButton)
        
    }
    
    func setupEmailLoginView(){
        startBorder = 1
        endBorder = 40
        tip1OnEmailLoginView.setUpLabel(text: "Please, enter your", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 8.5/14*self.view.bounds.height)
        tip2OnEmailLoginView.setUpLabel(text: "Email and password", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 9/14*self.view.bounds.height)
        
        emailTextField.setUpAnyTextField(width: self.view.bounds.width/1.8, height: UIScreen.main.bounds.height/18, textSize: self.view.bounds.width/35, colorText: Const.gray, colorBack: Const.grayAlpha, y: 9.8/14*self.view.bounds.height, placeholder: "custom@mail.ru", strokeColor: Const.gray)
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.setUpAnyTextField(width: self.view.bounds.width/1.8, height: UIScreen.main.bounds.height/18, textSize: self.view.bounds.width/35, colorText: Const.gray, colorBack: Const.grayAlpha, y: 10.8/14*self.view.bounds.height, placeholder: "", strokeColor: Const.gray)
        
        nextEmailButton.setUpButton(text: "next", colorText: Const.themeColor, colorBack: Const.green, textSize: customViews[1].bounds.width/17, y: 11.9/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20)
        resetButton.setUpButton(text: "Forgot password?", colorText: Const.mainBlueColor, colorBack: Const.transp, textSize: self.view.bounds.width/30, y: 12.7/14*self.view.bounds.height, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/15)
    }
    func setupResetView(){
        tip1OnEmailLoginView.setUpLabel(text: "Please, enter", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 8.5/14*self.view.bounds.height)
        tip2OnEmailLoginView.setUpLabel(text: " your Email", color: Const.gray, textSize: customViews[1].bounds.width/17, y: 9/14*self.view.bounds.height)
        nextEmailButton.setUpButtonWithX(text: "next", colorText: Const.themeColor, colorBack: Const.green, x: 4.6*view.bounds.width/9, textSize: customViews[1].bounds.width/17, y: 11/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20, borderColor: Const.greenCG, borderWidth: 0)
        backEmailButton.setUpButtonWithX(text: "back", colorText: Const.green, colorBack: Const.themeColor, x: 1.4*view.bounds.width/9, textSize: customViews[1].bounds.width/17, y: 11/14*self.view.bounds.height, width: view.bounds.width/3, height: view.bounds.height/20, borderColor: Const.greenCG, borderWidth: 1)
        
    }
    
    
    //ЛОГИН ПО ТЕЛЕФОНУ
    //открывает логин по телефону
    @objc
    private func openPhoneView(){
        wayOfSignIn = true
        disappearSecondPhone()
        view.bringSubviewToFront(customViews[1])
        customViews[1].animateUp(delta: view.bounds.height/1.4, delay: 0, duration: 0.2)
        closeMainCustomView()
    }
    //наполняет первое окно логина по телефону объектами
    func fillLoginWithPhoneCustomView(){
        setupFirstPhoneView()
        customViews[1].addSubview(phoneCustomViewTextField)
        customViews[1].addSubview(tip1OnPhoneCustomView)
        customViews[1].addSubview(nextPhoneCustomViewButton)
        phoneCustomViewTextField.addTarget(self, action: #selector(editingChangedPhone(_:)), for: .editingChanged)
        //phoneCustomViewTextField.addTarget(self, action: #selector(editingDidBegin(_:)), for: .editingDidBegin)
        
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
        DispatchQueue.main.async {
            self.sendCodeNet(phone: self.phoneCustomViewTextField.getRealPhone(phone: self.phoneCustomViewTextField.text ?? ""))
        }
    }
    @objc func decideToOpenApp(){
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
//    @objc func editingDidBegin(_ textField: UITextField) {
//        closeEditing.setUpButton(text: "", colorText: UIColor(red: 0, green: 0, blue: 0, alpha: 0), colorBack: UIColor(red: 0, green: 0, blue: 0, alpha: 0), textSize: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        closeEditing.addTarget(self, action: #selector(closeEditingAction(_:)), for: .touchUpInside)
//        //view.bringSubviewToFront(closeEditing)
//        view.addSubview(closeEditing)
//    }
//    @objc func closeEditingAction(_ textField: UITextField){
//        closeEditing.removeFromSuperview()
//        view.endEditing(true)
//    }
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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

   
    
//все переходы
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
//        isFlipped = !isFlipped
//        let fromview = isFlipped ? tb : self
//        let toview = isFlipped ? self : tb
//        self.transition(from: self, to: tb, duration: 0.4, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.transitionFlipFromLeft,UIView.AnimationOptions.showHideTransitionViews], animations: nil, completion: nil)

    }
  

    func showRegistration(){
        customViews[0].animateDown(delta: 7*view.bounds.width/8, delay: 0.1, duration: 0.3)
        logoText.alpha = 1
        
        let scaleDuration: TimeInterval = 0.8
        let textAnimationDuration: TimeInterval = 0.5
        let delay: TimeInterval = 0.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            UIView.animate(withDuration: scaleDuration, animations: {
                self.logoText.transform = CGAffineTransform(scaleX: 1.7, y: 1.7)
            }, completion: { (_) in
                
                UIView.animate(withDuration: textAnimationDuration, animations: {
                    Const.didAppearLogin = false
                    let frame = self.logoText.frame.offsetBy(dx: 0, dy: self.view.bounds.height/6)
                    self.logoText.frame = frame
                    self.logoText.alpha = 0
                }) { (true) in
                    let frame = self.logoText.frame.offsetBy(dx: 0, dy: -1*self.view.bounds.height/6)
                    self.logoText.frame = frame
                    let storyboard = UIStoryboard(name: "PhoneAuthSB", bundle: nil)
                    self.vc = storyboard.instantiateViewController(withIdentifier: "PhoneAuthViewContoller") as! PhoneAuthViewContoller
                    //let nc = UINavigationController.init(rootViewController: vc)
                    self.vc.modalPresentationStyle = .fullScreen
                    self.present(self.vc, animated: false)
                }
                
            })
            
        
        }
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        customViews[0].animateUp(delta: 7*view.bounds.width/8, delay: 0.1, duration: 0.3)
//
//    }
    @objc func logIn(){
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if (!email.isEmpty && !password.isEmpty){
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            isEnabledEverything(b: false)
            DispatchQueue.main.async {
                LoginNetworking.shared.login(email: email, password:password)
            }
        }
        else{
            showAlert(title: "Ошибка", message: "Заполните все поля")
        }

    }
    
    
    func sendCodeNet(phone: String){
        if phone != ""{
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            isEnabledEverything(b: false)
            NetworkingService.shared.sendCode(text: phone)
        }
        else{
            showAlert(title: "Ошибка", message: "Введите номер телефона")
            //disappearFirstPhone()
        }
    }
    @objc func checkCode(){
        let code = phoneCustomViewTextField.text
        if code != nil{
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            isEnabledEverything(b: false)
            NetworkingService.shared.showChecked = self
            NetworkingService.shared.check(codeForCheck: code ?? "")
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
        self.showMainTabBar()
        DispatchQueue.main.async {
            Account.shared.loadData()
            if !self.wayOfSignIn{
                self.setupEmailLoginView()
            }
            else{
                self.disappearSecondPhone()
            }
            
            self.openMainCustomView()
        }
    }
    
   
    
}
extension LoginViewController: LoginDelegate{
    func showAlertWithError(title: String, message: String) {
        showAlert(title: title, message: message)
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        isEnabledEverything(b: true)
    }
    func loginCompleted() {
        self.loginSucceeded()
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        isEnabledEverything(b: true)
    }
}

extension LoginViewController: PhoneCheckDelegate{
    func sendCodeReturn(b: Bool) {
        sendCodeRet = b
        if !b{
            showAlert(title: "Неверный номер телефона", message: "Попробуйте ввести ещё раз")
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            isEnabledEverything(b: true)
        }
        else{
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            isEnabledEverything(b: true)
            disappearFirstPhone()

        }
    }
    
    func checkingReturn(b: Bool) {
        checked = b
        if !checked{
            showAlert(title: "Неверный код", message: "Попробуйте ввести ещё раз")
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            isEnabledEverything(b: true)
        }
        else{
            loginSucceeded()
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            isEnabledEverything(b: true)
        }
        
    }
    
}
//extension LoginViewController: UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if (textField.returnKeyType == UIReturnKeyType.send){
//            self.checkCode()
//        }
//
//        if (textField.returnKeyType == UIReturnKeyType.next){
//            let nextTage=textField.tag+1;
//            let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
//            if (nextResponder != nil){
//                nextResponder?.becomeFirstResponder()
//            }
//            else{
//                textField.resignFirstResponder()
//            }
//        }
//        if (textField.returnKeyType == UIReturnKeyType.go){
//            logIn()
//        }
//        return true
//    }
//
//}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//
//
//    func presentMapVC(){
//        let theUsername = "testUser"
//        let storyboard = UIStoryboard.init(name: "MapViewController", bundle: nil)
//        let newViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
//               newViewController.modalPresentationStyle = .fullScreen
//               newViewController.textUsername = theUsername
//        let navC = UINavigationController.init(rootViewController: newViewController)
//        navC.modalPresentationStyle = .fullScreen
//        present(navC, animated: true, completion: nil)
//
//        self.beginAppearanceTransition(false, animated: true)
//        navC.beginAppearanceTransition(true, animated: true)
//        UIView.transition(from: self.view, to: navC.view, duration: 0.5, options: [.transitionCrossDissolve]) { (_) in
//            UIApplication.shared.delegate?.window??.rootViewController = navC
//        }
//        self.endAppearanceTransition()
//        navC.endAppearanceTransition()
//    }
//
