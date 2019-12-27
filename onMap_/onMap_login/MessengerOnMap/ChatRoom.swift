//

import Foundation
import Firebase

struct ChatRoom {
    var ownersArray: [String]   // массив отправителей сообщений
    var messagesArray: [String] // массив самих сообщений в чатруме
    var timesArray: [Date]    // массив времени отправки
    
    init() {
        ownersArray = []
        messagesArray = []
        timesArray = []
    }
    
    init(ownersArray: [String], messagesArray: [String], timesArray: [Date]) {
        self.ownersArray = ownersArray
        self.messagesArray = messagesArray
        self.timesArray = timesArray
    }
}

extension ChatRoom: ExploitDictonary {
    var dictonary: [String : Any] {
        return [
            "ownersArray" : ownersArray,
            "messagesArray" : messagesArray,
            "timesArray" : timesArray
        ]
    }
    
    init?(dictonary: [String : Any]) {
        guard
            let ownersArray = dictonary["ownersArray"] as? [String],
            let messagesArray = dictonary["messagesArray"] as? [String],
            let timesArray = dictonary["timesArray"] as? [Timestamp]
        else { return nil }
        
        self.ownersArray = ownersArray
        self.messagesArray = messagesArray
        self.timesArray = [Date]()
        for i in 0..<timesArray.count {
            self.timesArray.append(timesArray[i].dateValue())
        }
    }
}
