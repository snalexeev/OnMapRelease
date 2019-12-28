//


import Foundation
import Firebase
//import MapKit

final class FirestoreMessenger: MessengerOnMap {
    //singleton
    private static var singleton: MessengerOnMap?
    static var shared: MessengerOnMap {
        if FirestoreMessenger.singleton == nil {
            FirestoreMessenger.singleton = FirestoreMessenger()
        }
        return FirestoreMessenger.singleton!
    }
    private let pathRooms = "rooms" //  путь до документа с самими чатрумами
    private let pathChats = "chats" // путь до документа с информацией о чат
    private var db: Firestore!  //  database
    private var chatInformationArray: [ChatInfo] // Понятно что)
    private var idDiscussion: String?   //текущий чатрум
    private var currentChatRoom: ChatRoom?
    var listenerChat: ListenerRegistration?
    public var numberOfChats: Int { return chatInformationArray.count }
    public var countMessages: Int { return currentChatRoom?.messagesArray.count ?? 0 }
    private init() {
        db = Firestore.firestore()
        chatInformationArray = [ChatInfo]()
        currentChatRoom = nil
    }
    
    func setupObserverChats(_ completion: (() -> Void)?) {
        db.collection(pathChats).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else { return }
            snapshot.documentChanges.forEach { (diff) in
                if diff.type == .added {
                    //guard let data = diff.document.data() else { return }
                    self.chatInformationArray.append(ChatInfo(dictonary: diff.document.data())!)
                    completion?()
                }
                if diff.type == .removed {
                    let info = ChatInfo(dictonary: diff.document.data())
                    let name = info?.name
                    var c = 0
                    while c < self.chatInformationArray.count {
                        if self.chatInformationArray[c].name == name {
                            break
                        }
                        c += 1
                    }
                    if c < self.chatInformationArray.count {
                        self.chatInformationArray.remove(at: c)
                    }
                    completion?()
                }
            }
        }
    }
    
    func setupObserverChatRoom(_ completion: (() -> Void)?) {
        guard let documentPath = idDiscussion else { return }
        self.listenerChat = db.collection(pathRooms).document(documentPath).addSnapshotListener({ (documentSnapshot, error) in
            guard error == nil else { print(error?.localizedDescription as Any); return }
            guard let document = documentSnapshot else { return }
            guard let data = document.data() else { return }
            self.currentChatRoom = ChatRoom(dictonary: (data))
            completion?()
        })
    }
    
    func chatIsExist(name: String) -> Bool {
        return chatInformationArray.contains { (theChatInfo) -> Bool in
            theChatInfo.name == name
        }
    }
    
    func addChat(nameDiscussion: String, xCoordinate: Double, yCoordinate: Double) -> Bool {
        
        // проверка на уникальность имени
        guard !chatIsExist(name: nameDiscussion) else { return false } // вывести алерт с именем
        
        let newDiscussionRoom = ChatRoom()
        var newRoomLink: String = ""
        var ref: DocumentReference? = nil

        ref = self.db.collection(pathRooms).addDocument(data: newDiscussionRoom.dictonary, completion: { (error) in
            guard error == nil else { print(error?.localizedDescription as Any); return }
            print("CharRoom is created")
            newRoomLink = ref!.documentID
            print("referance - \(String(newRoomLink))")
        })
        
        var newChatInformation = ChatInfo(name: nameDiscussion,
                                                 timeCreate: Date(),
                                                 xCoordinate: xCoordinate,
                                                 yCoordinate: yCoordinate,
                                                 chatLink: ref!.documentID,
                                                 firebaseID: "не добавлен еще")
        
        ref = self.db.collection(pathChats).addDocument(data: newChatInformation.dictonary)
        newChatInformation.firebaseID = ref!.documentID
        self.db.collection(pathChats).document(ref!.documentID).setData(newChatInformation.dictonary)
        self.chatInformationArray.append(newChatInformation)
        
        return true
    }
    
    func loadChatInfoArray(_ completion: (() -> Void)?) {
        var tempChatInfoArray: [ChatInfo] = []
        self.db.collection(pathChats).getDocuments { (querySnapshot, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any);
                self.chatInformationArray.removeAll()
                return
            }
            for document in querySnapshot!.documents {
                let newChatInformation = ChatInfo(dictonary: document.data())
                if let newChatInformation = newChatInformation {
                    tempChatInfoArray.append(newChatInformation)
                }
                self.chatInformationArray = tempChatInfoArray
            }
            completion?()
        }
    }
    
    func getInfoAboutChat(index: Int) -> (name: String, timeCreate: Date, xCoordinate: Double, yCoordinate: Double, idDiscussion: String) {
        guard
            let name: String = chatInformationArray[index].name,
            let timeCreate: Date = chatInformationArray[index].timeCreate,
            let xCoordinate: Double = chatInformationArray[index].xCoordinate,
            let yCoordinate: Double = chatInformationArray[index].yCoordinate,
            let idDiscussion: String = chatInformationArray[index].chatLink
        else {
            return ("error", Date(), 0.0, 0.0, "nope")
        }
        return (name, timeCreate, xCoordinate, yCoordinate, idDiscussion)
    }
    
    func loadDiscussionRoom(_ completion: (() -> Void)?) {
        guard let idChat = idDiscussion else { return }
        var tempChatRoom: ChatRoom? = ChatRoom()
        db.collection(pathRooms).document(idChat).getDocument { (theDocumnentSnapshot, error) in
            guard error == nil else { print(error?.localizedDescription as Any); return }
            guard let data = theDocumnentSnapshot?.data() else { return }
            tempChatRoom = ChatRoom(dictonary: (data))
            self.currentChatRoom = tempChatRoom
            completion?()
        }
    }
    

    func sendMessage(owner: String, message: String) {
        if currentChatRoom == nil {
            currentChatRoom = ChatRoom()
        }
        guard let chatLink = self.idDiscussion else { return }
        currentChatRoom?.messagesArray.append(message)
        currentChatRoom?.ownersArray.append(owner)
        currentChatRoom?.timesArray.append(Date())
        self.db.collection(self.pathRooms).document(chatLink).setData(currentChatRoom!.dictonary)
    }
    
    func getInfoAboutMessage(index: Int) -> (message: String?, idOwner: String?, timeSend: Date?){
        return (currentChatRoom?.messagesArray[index],
                currentChatRoom?.ownersArray[index],
                currentChatRoom?.timesArray[index])
    }
    func startDiscussRoom(name: String) {
        currentChatRoom = nil
        for i in chatInformationArray {
            if i.name == name {
                self.idDiscussion = i.chatLink
                break
            }
        }
        self.loadDiscussionRoom(nil)
        
    }
    
    private func deleteObserverChatRoom() {
        listenerChat?.remove()
    }
    
    func closeDiscussRoom() {
        deleteObserverChatRoom()
        currentChatRoom = nil
    }
    func deleteChat(name: String) {
        var pathToRoom = ""
        var pathToInfo = ""
        for i in chatInformationArray {
            if (i.name == name) {
                pathToInfo = i.firebaseID
                pathToRoom = i.chatLink
                break
            }
        }
        var indexDelete = 0
        while indexDelete <= chatInformationArray.count {
            if chatInformationArray[indexDelete].name == name {
                break
            }
            indexDelete += 1
        }
        if indexDelete != chatInformationArray.count {
            chatInformationArray.remove(at: indexDelete)
        }
        self.db.collection(pathChats).document(pathToInfo).delete()
        self.db.collection(pathRooms).document(pathToRoom).delete()
        return
    }
}
