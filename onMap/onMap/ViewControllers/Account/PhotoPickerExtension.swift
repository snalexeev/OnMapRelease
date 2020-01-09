//
//  PhotoPickerExtension.swift
//  onMap
//
//  Created by Екатерина on 09/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import UIKit
extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PhotoUploadResultDelegate, ChooseSourceDelegate{
    func chosenSource(s: Character) {
        print("here")
        if s == "l"{
            getPhoto()
        }
        if s == "t"{
            takePhoto()

        }
    }
    
    func setupPhotoExtension() {
        //image = imageView.image!
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func choseUpload(){
        let vc = UIStoryboard(name: "ChooseActionWithPhotoController", bundle: nil).instantiateViewController(withIdentifier: "ChooseActionWithPhotoController") as! ChooseActionWithPhotoController
        vc.chosenDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func getPhoto() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    func takePhoto() {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    func setupProfilePhoto(minY: CGFloat)->UIImageView{
        image = Account.shared.getPhoto() ?? UIImage(named: "standartAvatar")!
        let cell = UITableViewCell()
        let imageHeight = cell.frame.size.height*1.5
        let newImage = resizeImage(image: image, toTheSize: CGSize(width: imageHeight, height: imageHeight))
        let imageView = UIImageView.init(image: newImage)
        imageView.backgroundColor = Const.accountElements
        imageView.layer.position = CGPoint(x: leftInsetNormal*2, y: minY)
        imageView.layer.cornerRadius = imageHeight/2
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        image = info[.originalImage] as! UIImage
        DispatchQueue.main.async {
            PhotoNetworking.shared.uploadPhoto(image: self.image)
        }
        
    }
    
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showAlert(title: String, message: String) {
        showError(title: title, message: message)
    }
    
    func completed() {
        DispatchQueue.main.async {
            Account.shared.loadData()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
