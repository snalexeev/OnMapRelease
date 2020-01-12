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
        
        
    }
}
