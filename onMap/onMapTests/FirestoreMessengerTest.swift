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
    private let bd: MessengerOnMap = FirestoreMessenger.shared
    public var result: Bool {
        return numberOfEndChats - numberOfStartChats == numberOfTestingChats
        //удалить чаты
    }
    
    var numberOfTestingChats: Int = 0
    var numberOfStartChats: Int = 0
    var numberOfEndChats: Int = 0
    func startTestAddChat(n: Int) {
        numberOfTestingChats = n
        bd.loadChatInfoArray {
            self.numberOfStartChats = self.bd.numberOfChats
        }
        sleep(1)
        let name: String = "testhahaha101010"
        for i in 0..<n {
            let key = bd.addChat(nameDiscussion: name + String(i), xCoordinate: 1.0, yCoordinate: 1.0)
            if key {
                numberOfTestingChats -= 1
            }
        }
        sleep(1)
        bd.loadChatInfoArray {
            self.numberOfEndChats = self.bd.numberOfChats
        }
        
    }
}
