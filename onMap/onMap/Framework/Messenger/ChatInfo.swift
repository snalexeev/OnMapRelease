// ChatInfo.swift

import Foundation
import Firebase

protocol ExploitDictonary {
    var dictonary: [String : Any] { get }
    init?(dictonary: [String : Any])
}

/// Description
struct ChatInfo {
    var name: String    //  имя чата
    var timeCreate: Date  //  время создания чата
    var xCoordinate: Double
    var yCoordinate: Double
    var chatLink: String    //  ссылка на чатрум
    var firebaseID: String //  id в firebase
}

extension ChatInfo: ExploitDictonary {
    var dictonary: [String : Any] {
        return [
            "name" : name,
            "timeCreate" : timeCreate,
            "xCoordinate" : xCoordinate,
            "yCoordinate" : yCoordinate,
            "chatLink" : chatLink,
            "firebaseID" : firebaseID
        ]
    }
    
    init?(dictonary: [String : Any]) {
        guard
            let name = dictonary["name"] as? String,
            let timeStamp = dictonary["timeCreate"] as? Timestamp,
            let xCoordinate = dictonary["xCoordinate"] as? Double,
            let yCoordinate = dictonary["yCoordinate"] as? Double,
            let chatLink = dictonary["chatLink"] as? String,
            let firebaseID = dictonary["firebaseID"] as? String
        else { return nil }
        
        self.name = name
        self.timeCreate = timeStamp.dateValue()
        self.xCoordinate = xCoordinate
        self.yCoordinate = yCoordinate
        self.chatLink = chatLink
        self.firebaseID = firebaseID
    }
}
