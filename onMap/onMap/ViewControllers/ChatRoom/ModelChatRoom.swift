//
//  ModelChatRoom.swift
//  onMap
//


import Foundation
import UIKit

struct MessageInfo {
    var idOwner: String
    var theMessage: String
    var time: String
}

final class ModelChatRoom {
    
    private let bd = FirestoreMessenger.shared
    //хранение аватарок пользователей
    private var buffer: [String : UIImage]
    // все сообщения
    
    public init() {
        buffer = [String : UIImage]()
    }
    deinit {
        buffer.removeAll()
    }
    
    public func setAvatarForCell(id: String, cell: MessageCell) {
//        if let image = buffer[id] {
//            if image != #imageLiteral(resourceName: "saucer") {
//                cell.imageAvatar = image
//            } else {
//                DispatchQueue.main.async { [cell]
//                    sleep(2)
//                    self.setAvatarForCell(id: id, cell: cell)
//                }
//            }
//            
//        } else {
//            buffer[id] = #imageLiteral(resourceName: "saucer")
//            Account.shared.loadPhotoByID(userID: id) { [weak cell] (newImage) in
//                self.buffer[id] = newImage
//                cell?.imageAvatar = newImage
//            }
//        }
        
    }
}
