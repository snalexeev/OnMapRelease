//
//  AccountLocalStorage.swift
//  onMap
//
//  Created by Екатерина on 12/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import RealmSwift
class AccountLocalStorage{
    private init() {}
    public static let shared = AccountLocalStorage()
    var items: Results<Person>!
    func setupRealm(){
        let realm = try! Realm()
        self.items = realm.objects(Person.self)
        if SettingOnMap.shared.first{
            SettingOnMap.shared.first = false
            let item = Person()
            item.id = ""
            try! realm.write {
                realm.add(item)
            }
        }
    }
    func checkPerson(id: String) -> Person{
        let realm = try! Realm()
        self.items = realm.objects(Person.self)
        for i in 0...items.count - 1{
            if items[i].id == id{
                return items[i]
            }
        }
        return items[0]
    }
    func addPerson(id: String, image: UIImage, name: String, surname: String){
        let realm = try! Realm()
        self.items = realm.objects(Person.self)
        let item = Person()
        let date = Date()
        item.date = date.description
        item.id = id
        item.name = name
        item.image = image
        item.surname = surname
        if self.items.count == 10{
            try! realm.write {
                realm.delete(items[1])
            }
        }
        try! realm.write {
            realm.add(item)
        }
        self.items = realm.objects(Person.self)
    }
    func updatePerson(id: String, image: UIImage, name: String, surname: String){
        let realm = try! Realm()
        self.items = realm.objects(Person.self)
        let item = Person()
        let date = Date()
        item.date = date.description
        item.id = id
        item.name = name
        item.image = image
        item.surname = surname
        var k = 0
        for i in 0...items.count - 1{
            if items[i].id == id{
                k = i
                break
            }
        }
        if self.items.count == 10{
            try! realm.write {
                realm.delete(items[k])
            }
        }
        try! realm.write {
            realm.add(item)
        }
        self.items = realm.objects(Person.self)
    }
    
}

