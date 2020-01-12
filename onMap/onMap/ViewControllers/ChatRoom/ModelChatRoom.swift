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
            var temp = theAvatar
            Account.shared.loadPhotoByID(userID: id) { (newImage) in
                self.buffer[id] = newImage
                temp = newImage
            }
        }
        
    }
}
