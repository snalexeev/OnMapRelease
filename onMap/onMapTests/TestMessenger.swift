//
//  TestMessenger.swift
//  onMapTests
//
//  Created by Sergei Alexeev on 14.01.2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
@testable import onMap

final class TestMessenger {
    var bd: MessengerOnMap = MessengerMock.shared
    
    func testAddChat() -> Bool {
        let n1 = bd.numberOfChats
        let name = "test12"
        bd.addChat(nameDiscussion: name, xCoordinate: 1, yCoordinate: 1)
        let n2 = bd.numberOfChats
        return (n2 == n1 + 1)
    }
    
    func testSend() -> Bool {
        let name = "test22"
        bd.addChat(nameDiscussion: name, xCoordinate: 1, yCoordinate: 1)
        bd.startDiscussRoom(name: name)
        bd.sendMessage(owner: "testUser", message: "help")
        return bd.countMessages == 1
    }
    
}
