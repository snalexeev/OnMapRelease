// MessengerOnMap.swift

import Foundation
import MapKit

/**
 Protocol (interface) that is required for working with dialogs
 - Создание чатов
 - Удаление чатов
 - Отправка сообщений
 - Получение информации о чатах
 - Получение сообщений в чате
 */
protocol MessengerOnMap {
    ///singleton property
    static var shared: MessengerOnMap { get }
    /// Number of chats in the database
    var numberOfChats: Int { get }
    /// Number of messages in the chat currently in use
    var countMessages: Int { get }
    /// Normal initialization, no need to create more than one
    /**
     Method to create a new chat provided that there is an Internet connection
     
     ```
     "newChat", 1.1, 1.1 -> true
     "newChat", 2.1, 2.1 -> false
     ```
     
     - parameters:
        - nameDiscussion: The unique name of the chat
        - xCoordinate: Latitude
        - yCoordinate: Llongitude
     
     - returns: Returns information about whether a chat has been created
    */
    func addChat(nameDiscussion: String, xCoordinate: Double, yCoordinate: Double) -> Bool
    /**
     Create an observer that will perform the closure (completion)
     ```
     nil OK!
     { print("triggered"} OK!
     ```
     - parameters:
        - completion: Closure to be performed when triggered
    */
    func setupObserverChats(_ completion: (() -> Void)?)
    /**
     The method loads the information about all the chats
     ```
     nil OK!
     { print("triggered"} OK!
     ```
     - parameters:
        - completion: Closure to be performed when triggered
     
     - returns: primer
    */
    func loadChatInfoArray(_ completion: (() -> Void)?)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func getInfoAboutChat(index: Int) -> (name: String, timeCreate: Date, xCoordinate: Double, yCoordinate: Double, idDiscussion: String)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func chatIsExist(name: String) -> Bool
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func sendMessage(owner: String, message: String)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func setupObserverChatRoom(_ completion: (() -> Void)?)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func loadDiscussionRoom(_ completion: (() -> Void)?)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func getInfoAboutMessage(index: Int) -> (message: String?, idOwner: String?, timeSend: Date?)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func startDiscussRoom(name: String)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: promer
     
     - returns: primer
    */
    func closeDiscussRoom()
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: primer
     
     - returns: primer
    */
    func deleteChat(name: String)
    /**
     Method primew
     ```
     "newChat", 1.1, 1.1 -> true
     ```
     - parameters:
        - promer: primer
     
     - returns: primer
    */
}

