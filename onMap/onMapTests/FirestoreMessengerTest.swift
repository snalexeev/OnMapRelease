//
//  FirestoreMessengerTest.swift
//  onMapTests
//
//  Created by Sergei Alexeev on 10.01.2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
@testable import onMap

class FirestoreMessengerTest {
    let bd = FirestoreMessenger.shared
    
    func testAddChat() {
        let name = "testtesttest12test12"
        bd.addChat(nameDiscussion: name, xCoordinate: 1.0, yCoordinate: 2.0)
//        bd.loadChatInfoArray {
//
//        }
//        sleep(1)
//        bd.chatIsExist(name: name)
    }
    
    var resultAddChat: Bool {
        return false
    }
    
    func testSendMessage() {
        
        
        
        

    }
    
    var resultSendChat: Bool {
        return false
    }
}
