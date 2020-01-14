//
//  FirestoreMessengerTest.swift
//  onMapTests
//
//  Created by Sergei Alexeev on 14.01.2020.
//  Copyright © 2020 onMap. All rights reserved.
//

// firestore не работает с юнит тестами (спасибо гугл), поэтому делаем мок обьект

import Foundation
@testable import onMap

final class MessengerMock : MessengerOnMap {
    private static var singleton: MessengerOnMap?
    static var shared: MessengerOnMap {
        if MessengerMock.singleton == nil {
            MessengerMock.singleton = MessengerMock()
        }
        return MessengerMock.singleton!
    }

    private var chatInformationArray: [ChatInfo] // Понятно что)
    private var idDiscussion: String?   //текущий чатрум
    private var currentChatRoom: ChatRoom?
    
    var numberOfChats: Int { return chatInformationArray.count }

    var countMessages: Int { return currentChatRoom?.messagesArray.count ?? 0 }

    private init() {
        chatInformationArray = [ChatInfo]()
        currentChatRoom = nil
    }

    func check(_ completionIfError: (() -> Void)?) {
        //nothing
    }

    func addChat(nameDiscussion: String, xCoordinate: Double, yCoordinate: Double) -> Bool {
        chatInformationArray.append(ChatInfo(name: nameDiscussion, timeCreate: Date(), xCoordinate: xCoordinate, yCoordinate: yCoordinate, chatLink: "test", firebaseID: "test"))
        return true
    }

    func setupObserverChats(_ completion: (() -> Void)?) {
        //nothing
    }

    func loadChatInfoArray(_ completion: (() -> Void)?) {
        //nothing
    }

    func getInfoAboutChat(index: Int) -> (name: String, timeCreate: Date, xCoordinate: Double, yCoordinate: Double, idDiscussion: String) {
        let info = chatInformationArray[index]
        return (name: info.name, timeCreate: Date(), xCoordinate: 1, yCoordinate: 1, idDiscussion: "heh")
    }

    func chatIsExist(name: String) -> Bool {
        return chatInformationArray.contains { (theChatInfo) -> Bool in
            theChatInfo.name == name
        }
    }

    func sendMessage(owner: String, message: String) {
        currentChatRoom?.messagesArray.append(message)
        currentChatRoom?.ownersArray.append(owner)
        currentChatRoom?.timesArray.append(Date())
    }

    func setupObserverChatRoom(_ completion: (() -> Void)?) {
        //nothing
    }

    func loadDiscussionRoom(_ completion: (() -> Void)?) {
        //nothing
    }

    func getInfoAboutMessage(index: Int) -> (message: String?, idOwner: String?, timeSend: Date?) {
        return (message: currentChatRoom?.messagesArray[index], idOwner: currentChatRoom?.ownersArray[index], timeSend: Date())
    }

    func startDiscussRoom(name: String) {
        currentChatRoom = ChatRoom(ownersArray: [], messagesArray: [], timesArray: [])
    }

    func closeDiscussRoom() {
        currentChatRoom = nil
    }

    func deleteChat(name: String) {

        var indexDelete = 0
        while indexDelete <= chatInformationArray.count {
            if chatInformationArray[indexDelete].name == name {
                break
            }
            indexDelete += 1
        }
        if indexDelete <= chatInformationArray.count {
            chatInformationArray.remove(at: indexDelete)
        }
    }
}


