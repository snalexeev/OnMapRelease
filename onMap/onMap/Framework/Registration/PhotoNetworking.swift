//
//  PhotoNetworking.swift
//  onMap_login
//
//  Created by Екатерина on 27/10/2019.
//  Copyright © 2019 Екатерина. All rights reserved.
//

import Foundation
import Firebase
import UIKit
protocol PhotoUploadResultDelegate {
    func showAlert(title: String, message: String)
    func completed()
}
class PhotoNetworking {
    private init() {}
    public static let shared = PhotoNetworking()
    var resultDelegate: PhotoUploadResultDelegate?
    func uploadPhoto(image: UIImage){
        let id = Auth.auth().currentUser?.uid ?? ""
        let userProfilesRef = Storage.storage().reference().child("images/profiles")
        if let uploadData = image.pngData(){
            let uploadUserProfileTask = userProfilesRef.child(String(id)+".png").putData(uploadData, metadata: nil) { (metadata, error) in
                if metadata == nil{
                   self.resultDelegate?.showAlert(title: "Ошибка", message: error?.localizedDescription ?? "")
                  return
                }
                else{
                    Account.shared.setDate(date: Date().description, id: id)
                    self.resultDelegate?.completed()
                }
                
            }
        }
    }
}
