//
//  AddChatMock.swift
//  
//
//  Created by Sergei Alexeev on 11.12.2019.
//

import Foundation
@testable import OnMapRelease

final class AddChatMock {
    let bd = FirestoreMessenger.shared
    var count: Int {
        get {
            return bd.numberOfChats
        }
    }
    init() {
        bd.loadChatInfoArray(nil)
    }
    
    func addChatTest() -> Bool {
        return bd.addChat(nameDiscussion: "TESTTES", xCoordinate: 24, yCoordinate: 24)
    }
    
    deinit {
        bd.deleteChat(name: "TESTTES")
    }
}
