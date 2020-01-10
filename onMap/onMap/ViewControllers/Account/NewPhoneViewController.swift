//
//  ViewController.swift
//  onMap
//
//  Created by Екатерина on 10/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import UIKit
class NewPhoneViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    let barButtonNext = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextTo))
    var header = ""
    var footer = ""
    var newPhone = ""
    var phoneTextField = UITextField()
    var leftInset = CGFloat()
    var which = false
    var text = ""
    let hideKeyboardGesture =  UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingService.shared.showChecked = self
        NetworkingService.shared.showAlertDelegate = self
        navigationItem.rightBarButtonItem = barButtonNext
        let cell = UITableViewCell()
        leftInset = 6*cell.frame.size.height/11
        header = "New phone"
        footer = "We will send you verification code"
        text = "+7 (123) 456-78-99"
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
            which = true
            DispatchQueue.main.async {
                self.newPhone = self.phoneTextField.getRealPhone(phone: self.phoneTextField.text ?? "+")
                NetworkingService.shared.sendCode(text: self.newPhone)
            }
        }
        else{
            DispatchQueue.main.async {
                NetworkingService.shared.updatePhone(codeForCheck: self.phoneTextField.text ?? "")
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
                phoneTextField.addTarget(self, action: #selector(editingChangedPhone(_:)), for: .editingChanged)
            }
            else{
                phoneTextField.removeTarget(self, action: #selector(editingChangedPhone(_:)), for: .editingChanged)
            }
            
            phoneTextField.addTarget(self, action: #selector(endEditingTextField), for: .editingDidEnd)
            cell.addSubview(phoneTextField)
       
        default:
            break
        }
        return cell
        
    }
    @objc func editingChangedPhone(_ textField: UITextField) {
        if textField.text != ""{
            textField.text = textField.workWithPhone(phone: textField.text ?? "+")
        }
        else{
            textField.text = "+"
        }
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

extension NewPhoneViewController: PhoneCheckDelegate, ShowAlertDelegate{
    
    func showNext(from: Int) {
        //
    }
    
    func checkingReturn(b: Bool) {
        if b{
            Account.shared.setPhone(phone: newPhone)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func sendCodeReturn(b: Bool) {
        if b{
            header = ""
            footer = "We have sent you SMS"
            text = "code"
            reloadTable()
        }
        else{
            showAlert(title: "Ошибка", message: "Неверный номер телефона")
        }
        
    }
    
    
}
