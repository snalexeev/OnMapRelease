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

struct OtherMessageInfo {
    var avatar: UIImage
    var nameOwner: String
}

final class ModelChatRoom {
    
    public var name: String
    
    public var bd: MessengerOnMap = FirestoreMessenger.shared
    //хранение аватарок пользователей
    private var buffer: [String : OtherMessageInfo]
    
    
    public var countMessages: Int {
        return bd.countMessages
    }
    public init() {
        name = "error"
        buffer = [String : OtherMessageInfo]()
    }
    
    public init(name: String) {
        buffer = [String : OtherMessageInfo]()
        self.name = name
        bd.startDiscussRoom(name: name)
    }
    
    deinit {
        buffer.removeAll()
    }

    
    public func closeChatRoom() {
        bd.closeDiscussRoom()
    }
    
    public func loadInfoForTable(_ completion: (() -> Void)?) {
        bd.loadDiscussionRoom {
            completion?()
        }
    }
    
    public func setupObserver(_ completion: (() -> Void)?) {
        bd.setupObserverChatRoom {
            completion?()
        }
    }
    
    public func sendMessage(owner: String, message: String) {
        bd.sendMessage(owner: owner, message: message)
    }
    
    public func deleteChat() {
        bd.deleteChat(name: self.name)
    }
    
    public func getInfoMessage(index: Int) -> (message: String?, idOwner: String?, timeSend: Date?) {
        return bd.getInfoAboutMessage(index: index)
    }
    
    public func setAvatarAndOwnerMessage(id: String, cell: MessageCell) {
        if let info = buffer[id] {
            cell.imageAvatar = info.avatar
            cell.textOwner = info.nameOwner
        } else {
            Account.shared.loadInfoByID(userID: id) { [ weak cell ] (avatar, name, surname) in
                let info = OtherMessageInfo(avatar: avatar, nameOwner: name + " " + surname + ":")
                self.buffer[id] = info
                cell?.imageAvatar = info.avatar
                cell?.textOwner = info.nameOwner
            }
        }
    }
}
