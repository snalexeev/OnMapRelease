//
//  ModelChatRoom.swift
//  onMap
//
//  Created by Sergei Alexeev on 12.01.2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import UIKit

final class ModelChatRoom {
    //хранение аватарок пользователей
    var buffer: [String : UIImage]
    
    
    init() {
        buffer = [String : UIImage]()
    }
    deinit {
        buffer.removeAll()
    }
    
    func setAvatarForCell(id: String, theAvatar: inout UIImage?) {
        if let image = buffer[id] {
            theAvatar = image
        } else {
            buffer[id] = #imageLiteral(resourceName: "standartAvatar")
            Account.shared.loadPhotoByID(userID: id) { [weak theAvatar] (newImage) in
                self.buffer[id] = newImage
                theAvatar = newImage
            }
        }
        
    }
}
