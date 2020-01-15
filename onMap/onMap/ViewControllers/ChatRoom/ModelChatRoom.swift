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
    private var que1: [String] = []
    private var que2: [MessageCell] = []
    
    
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
        que1.removeAll()
        que2.removeAll()
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
        bd.closeDiscussRoom()
    }
    
    public func getInfoMessage(index: Int) -> (message: String?, idOwner: String?, timeSend: Date?) {
        return bd.getInfoAboutMessage(index: index)
    }
    
    public func setAvatarAndOwnerMessage(id: String, cell: MessageCell) {
        if let info = buffer[id] {
            if info.nameOwner != "download" {
                cell.imageAvatar = info.avatar
                cell.textOwner = info.nameOwner
            } else {
                que1.append(id)
                que2.append(cell)
            }
        } else {
            buffer[id] = OtherMessageInfo(avatar: #imageLiteral(resourceName: "deleteButton"), nameOwner: "download")
            que1.append(id)
            que2.append(cell)
            Account.shared.loadInfoByID(userID: id) { [ weak cell ] (avatar, name, surname) in
                let info = OtherMessageInfo(avatar: avatar, nameOwner: name + " " + surname + ":")
                self.buffer[id] = info
                cell?.imageAvatar = info.avatar
                cell?.textOwner = info.nameOwner
                
                for i in 0..<self.que1.count {
                    if self.que1[i] == id {
                        DispatchQueue.main.async {
                            self.que2[i].imageAvatar = info.avatar
                            self.que2[i].textOwner = info.nameOwner
//
//                            self.que1.remove(at: i)
//                            self.que2.remove(at: i)
                        }
                    }
                }
            }
        }
    }
}
