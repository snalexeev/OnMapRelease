//
//  AccountTableViewExtension.swift
//  onMap
//
//  Created by Екатерина on 09/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import UIKit
extension AccountViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 2
         default:
           return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            return firstFooterTitle.text
        case 1:
            return secondFooterTitle.text
        default:
            return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2{
            switch indexPath.row {
            case 0:
                changeNumber()
                tableView.deselectRow(at: indexPath, animated: true)
            case 1:
                changeEmail()
                tableView.deselectRow(at: indexPath, animated: true)
            default:
                break
            }
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! AccountTableViewCell
        cell.backgroundColor = Const.accountElements
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if reuse[0]{
                    reuse[0] = false
                    cell.selectionStyle = .none
                    profileUIImageView = setupProfilePhoto(minY: cell.bounds.maxY)
                    cell.addSubview(profileUIImageView)
                    nameTextField = cell.nameTextField
                    nameTextField.tintColor = Const.accountText
                    cell.setupNameCell(viewWidth: view.frame.width, leftInset: leftInset*1.1)
                    nameTextField.addTarget(self, action: #selector(beginEditingAction(_:)), for: .editingDidBegin)
                    nameTextField.addTarget(self, action: #selector(endEditingActionName(_:)), for: .editingDidEnd)
                    nameTextField.text = name
                    cell.addSubview(nameTextField)
                    cell.separatorInset = .init(top: 0, left: leftInset, bottom: 0, right: 0)
                }
                else{
                    let index = IndexPath(row: 0, section: 0)
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
            case 1:
                if reuse[1]{
                    reuse[1] = false
                    cell.selectionStyle = .none
                    profileUIImageView = setupProfilePhoto(minY: cell.bounds.minY)
                    cell.addSubview(profileUIImageView)
                    surnameTextField = cell.surnameTextField
                    surnameTextField.addTarget(self, action: #selector(beginEditingAction(_:)), for: .editingDidBegin)
                    surnameTextField.addTarget(self, action: #selector(endEditingActionSurname(_:)), for: .editingDidEnd)
                    surnameTextField.tintColor = Const.accountText
                    cell.setupSurnameCell(viewWidth: view.frame.width, leftInset: leftInset*1.1)
                    surnameTextField.text = surname
                    cell.addSubview(surnameTextField)
                }
                else{
                    let index = IndexPath(row: 1, section: 0)
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
                
            default:
                break
            }
        case 1:
            if reuse[2]{
                reuse[2] = false
                aboutTextField = cell.aboutTextField
                cell.selectionStyle = .none
                cell.setupAboutCell(viewWidth: view.frame.width, leftInset: leftInsetNormal)
                aboutTextField.addTarget(self, action: #selector(beginEditingAction(_:)), for: .editingDidBegin)
                aboutTextField.addTarget(self, action: #selector(endEditingActionStatus(_:)), for: .editingDidEnd)
                aboutTextField.text = status
                aboutTextField.tintColor = Const.accountText
                cell.addSubview(aboutTextField)
            }
            else{
                let index = IndexPath(row: 0, section: 1)
                self.tableView.reloadRows(at: [index], with: .automatic)
            }
        case 2:
            switch indexPath.row{
            case 0:
                if reuse[3]{
                    reuse[3] = false
                    cell.setupTipPhoneLabel(viewWidth: view.frame.width, leftInset: leftInsetNormal)
                    cell.setupPhoneLabel(viewWidth: view.frame.width, phone: phone, rightInset: leftInsetNormal*2)
                    phoneLabel = cell.phoneLabel
                    changePhoneLabel = cell.changePhoneLabel
                    cell.addSubview(phoneLabel)
                    cell.addSubview(changePhoneLabel)
                    cell.accessoryType = .disclosureIndicator
                }
                else{
                    let index = IndexPath(row: 0, section: 2)
                    cell.accessoryType = .disclosureIndicator
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
            case 1:
                if reuse[4]{
                    reuse[4] = false
                    cell.setupTipEmailLabel(viewWidth: view.frame.width, leftInset: leftInsetNormal)
                    cell.setupEmailLabel(viewWidth: view.frame.width, email: email, rightInset: leftInsetNormal*2)
                    emailLabel = cell.emailLabel
                    changeEmailLabel = cell.changeEmailLabel
                    cell.addSubview(emailLabel)
                    cell.addSubview(changeEmailLabel)
                    cell.accessoryType = .disclosureIndicator
                }
                else{
                    let index = IndexPath(row: 1, section: 2)
                    cell.accessoryType = .disclosureIndicator
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
            default:
                break
            }
            
            
        case 3:
            switch indexPath.row {
            case 0:
                if reuse[5]{
                    reuse[5] = false
                    cell.setupExitButton(viewWidth: view.frame.width)
                    exitButton = cell.exitButton
                    exitButton.addTarget(self, action: #selector(exit), for: .touchUpInside)
                    cell.addSubview(exitButton)
                }
                else{
                    let index = IndexPath(row: 0, section: 3)
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
            case 1:
                if reuse[6]{
                    reuse[6] = false
                    cell.setupDeleteButton(viewWidth: view.frame.width)
                    deleteButton = cell.deleteButton
                    deleteButton.addTarget(self, action: #selector(deleteAccount), for: .touchUpInside)
                    cell.addSubview(deleteButton)
                }
                else{
                    let index = IndexPath(row: 1, section: 3)
                    self.tableView.reloadRows(at: [index], with: .automatic)
                }
            default:
                break
            }
            
       
        default:
            break
        }
        return cell
    }

    
    @objc func beginEditingAction(_ textField: UITextField){
        tableView.addGestureRecognizer(hideKeyboardGesture)
    }
   
    @objc func endEditingActionName(_ textField: UITextField){
        tableView.removeGestureRecognizer(hideKeyboardGesture)
        changeName()
    }
    @objc func endEditingActionSurname(_ textField: UITextField){
        tableView.removeGestureRecognizer(hideKeyboardGesture)
        changeSurname()
           
    }
    @objc func endEditingActionStatus(_ textField: UITextField){
        tableView.removeGestureRecognizer(hideKeyboardGesture)
        changeStatus()
          
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
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage?{
        let scale = CGFloat(max(size.width/image.size.width,
            size.height/image.size.height))
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;

        let rr:CGRect = CGRect(x: 0, y: 0, width: width, height: height);
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage
    }
}

class AccountTableViewCell: UITableViewCell {
    var nameTextField = UITextField()
    var surnameTextField = UITextField()
    var aboutTextField = UITextField()
    var exitButton = UIButton()
    var changePhoneLabel = UILabel()
    var changeEmailLabel = UILabel()
    var phoneLabel = UILabel()
    var emailLabel = UILabel()
    var deleteButton = UIButton()
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
    func setupNameCell(viewWidth: CGFloat, leftInset: CGFloat){
        nameTextField.setUpAccountTextField(width: viewWidth-leftInset, height: self.frame.size.height, textSize: self.frame.size.height/2, colorText: Const.accountText , colorBack: Const.transp, y: self.bounds.minY, placeholder: "Имя", strokeColor: Const.gray, x:self.frame.minX + leftInset)
    }
    func setupSurnameCell(viewWidth: CGFloat, leftInset: CGFloat){
            surnameTextField.setUpAccountTextField(width: viewWidth-leftInset, height: self.frame.size.height, textSize: self.frame.size.height/2, colorText: Const.accountText, colorBack: Const.transp, y: self.bounds.minY, placeholder: "Фамилия", strokeColor: Const.gray, x:self.frame.minX + leftInset)
    }
    func setupAboutCell(viewWidth: CGFloat, leftInset: CGFloat){
           aboutTextField.setUpAccountTextField(width: viewWidth-leftInset, height: self.frame.size.height, textSize: self.frame.size.height/2, colorText: Const.accountText, colorBack: Const.transp, y: self.bounds.minY, placeholder: "О себе", strokeColor: Const.gray, x:self.frame.minX + leftInset)
    }
    func setupExitButton(viewWidth: CGFloat){
        exitButton.setUpAccountButton(text: "выйти", colorText: .systemRed, colorBack: Const.transp, textSize: self.frame.size.height/2, y: self.bounds.minY, width: viewWidth, height: self.frame.size.height)
    }
    func setupTipEmailLabel(viewWidth: CGFloat, leftInset: CGFloat){
        changeEmailLabel.setUpLabelWithX(text: "Изменить email", color: Const.accountText, textSize: self.frame.size.height/2, y: self.bounds.minY + self.frame.size.height/4, x: leftInset, align: "l", width: viewWidth/2)
    }
    func setupTipPhoneLabel(viewWidth: CGFloat,  leftInset: CGFloat){
        changePhoneLabel.setUpLabelWithX(text: "Изменить телефон", color: Const.accountText, textSize: self.frame.size.height/2, y: self.bounds.minY + self.frame.size.height/4, x: leftInset, align: "l", width: viewWidth/2)
    }
    func setupPhoneLabel(viewWidth: CGFloat, phone: String,  rightInset: CGFloat){
        phoneLabel.setUpLabelWithX(text: changePhoneLabel.workWithPhone(phone: phone), color: Const.accountTextTransp, textSize: self.frame.size.height/2, y: self.bounds.minY + self.frame.size.height/4, x: viewWidth/2, align: "r", width: viewWidth/2 - rightInset)
    }
    func setupEmailLabel(viewWidth: CGFloat, email: String, rightInset: CGFloat){
        emailLabel.setUpLabelWithX(text: email, color: Const.accountTextTransp, textSize: self.frame.size.height/2, y: self.bounds.minY + self.frame.size.height/4, x: viewWidth/2, align: "r", width: viewWidth/2 - rightInset)
    }
    func setupDeleteButton(viewWidth: CGFloat){
        deleteButton.setUpAccountButton(text: "удалить аккаунт", colorText: .systemRed, colorBack: Const.transp, textSize: self.frame.size.height/2, y: self.bounds.minY, width: viewWidth, height: self.frame.size.height)
    }

}
