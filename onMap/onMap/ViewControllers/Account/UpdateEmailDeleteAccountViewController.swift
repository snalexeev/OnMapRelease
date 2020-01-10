//
//  UpdateEmailDeleteAccountViewController.swift
//  onMap
//
//  Created by Екатерина on 10/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import UIKit


class UpdateEmailDeleteAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let barButtonNext = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTo))
    var header = ""
    var footer = ""
    var phoneTextField = UITextField()
    var leftInset = CGFloat()
    var which = false
    var text = ""
    let hideKeyboardGesture =  UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        which = Const.updateDelete
        Account.shared.accountDelegateForConfirmation = self
        NetworkingService.shared.showAlertDelegate = self
        navigationItem.rightBarButtonItem = barButtonNext
        let cell = UITableViewCell()
        leftInset = 6*cell.frame.size.height/11
        if !which{
            header = "новый Email"
            footer = ""
            text = "custom@mail.ru"
        }
        else{
            header = "ваш пароль"
            footer = "Для удаления аккаунта в целях безопасности необходимо ввести пароль от учётной записи"
            text = "пароль"
        }
        
        self.view.backgroundColor = Const.transp
        tableView.backgroundColor = Const.accountback
        self.view.addSubview(self.tableView)
        self.tableView.register(PhoneTableViewCell.self, forCellReuseIdentifier: "PhoneTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.updateLayout(with: self.view.frame.size)
        hideKeyboardGesture.addTarget(self, action: #selector(hideKeyboard))
        // Do any additional setup after loading the view.
    }
    func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (contex) in
            self.updateLayout(with: size)
        }, completion: nil)
    }
    
    func reloadTable(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @objc func nextTo(){
        if !which{
            DispatchQueue.main.async {
                let email = self.phoneTextField.text ?? ""
                NetworkingService.shared.updateEmail(email: email)
            }
        }
        else{
            DispatchQueue.main.async {
                Account.shared.deleteAccount(password: self.phoneTextField.text ?? " ")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return footer
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return header
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhoneTableViewCell", for: indexPath) as! PhoneTableViewCell
        cell.backgroundColor = Const.accountElements
        switch indexPath.row {
        case 0:
            cell.setupPhoneTextField(viewWidth: view.frame.width, leftInset: leftInset, text: text)
            phoneTextField = cell.phoneTextField
            phoneTextField.addTarget(self, action: #selector(becomeFirstResponder), for: .editingDidBegin)
            if !which{
                phoneTextField.isSecureTextEntry = false
            }
            else{
                phoneTextField.isSecureTextEntry = true
            }
            phoneTextField.addTarget(self, action: #selector(endEditingTextField), for: .editingDidEnd)
            cell.addSubview(phoneTextField)
            
        default:
            break
        }
        return cell
        
    }
    
    @objc func endEditingTextField(){
        tableView.removeGestureRecognizer(hideKeyboardGesture)
    }
    @objc func beginEditingTextField(){
        tableView.addGestureRecognizer(hideKeyboardGesture)
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    @objc func hideKeyboard(){
        tableView.endEditing(true)
    }
    
    
}

extension UpdateEmailDeleteAccountViewController: ShowAlertDelegate, AccountDelegateForConfirmation{
    func showErrorWithConfirmation(error: String) {
        showAlert(title: "Ошибка", message: error)
        phoneTextField.text = ""
    }
    
    func dismissConfirmation() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    func showNext(from: Int) {
        Account.shared.setEmail(email: phoneTextField.text ?? "")
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    
}
