//
//  TestChatRoomModel.swift
//  onMapTests
//
//  Created by Sergei Alexeev on 15.01.2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import XCTest
@testable import onMap

class TestChatRoomModel: XCTestCase {
    

    func testSendMessage() {
        let name = "siptest"
        let bd = MessengerMock.shared
        bd.addChat(nameDiscussion: name, xCoordinate: 1, yCoordinate: 1)
        bd.startDiscussRoom(name: name)
        let model = ModelChatRoom()
        model.bd = bd
        
        let n1 = model.countMessages
        model.sendMessage(owner: "jj", message: "testjj")
        let n2 = model.countMessages
        XCTAssert(n2 == n1 + 1, "отправка сообщения")
    }

    func testGetModel() {
        let name = "siptest"
        let bd = MessengerMock.shared
        bd.addChat(nameDiscussion: name, xCoordinate: 1, yCoordinate: 1)
        bd.startDiscussRoom(name: name)
        let model = ModelChatRoom()
        model.bd = bd
        
        let message = "testjj"
        model.sendMessage(owner: "jj", message: message)
        XCTAssert(model.getInfoMessage(index: model.countMessages - 1).message == message, "получение информации о сообщении")
    }

}
