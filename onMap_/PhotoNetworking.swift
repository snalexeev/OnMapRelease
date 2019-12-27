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
class PhotoNetworking {
    private init() {}
    public static let shared = PhotoNetworking()
    func uploadPhoto(image: UIImage){
        let id = Auth.auth().currentUser?.uid ?? ""
        let userProfilesRef = Storage.storage().reference().child("images/profiles")
        if let uploadData = image.pngData(){
            let uploadUserProfileTask = userProfilesRef.child(String(id)+".png").putData(uploadData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                  print("Error occurred: \(error)")
                  return
                }
            }
        }
        else{
            print("11")
        }
    }
}
