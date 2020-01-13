// MessengerOnMap.swift

import Foundation
//import MapKit

protocol MessengerOnMap {
    
    static var shared: MessengerOnMap { get }
    var numberOfChats: Int { get }
    var countMessages: Int { get }
    func check(_ completionIfError: (() -> Void)?)
    func addChat(nameDiscussion: String, xCoordinate: Double, yCoordinate: Double) -> Bool
    func setupObserverChats(_ completion: (() -> Void)?)
    func loadChatInfoArray(_ completion: (() -> Void)?)
    func getInfoAboutChat(index: Int) -> (name: String, timeCreate: Date, xCoordinate: Double, yCoordinate: Double, idDiscussion: String)
    func chatIsExist(name: String) -> Bool
    func sendMessage(owner: String, message: String)
    func setupObserverChatRoom(_ completion: (() -> Void)?)
    func loadDiscussionRoom(_ completion: (() -> Void)?)
    func getInfoAboutMessage(index: Int) -> (message: String?, idOwner: String?, timeSend: Date?)
    func startDiscussRoom(name: String)
    func closeDiscussRoom()
    func deleteChat(name: String)
}

