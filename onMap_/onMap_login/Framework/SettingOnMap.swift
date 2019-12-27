//
//  SettingsOnMap.swift
//  onMap
//

import Foundation
import MapKit
import RealmSwift

class SettingOnMap {
    private static var singleton: SettingOnMap?
    public static var shared: SettingOnMap {
        if singleton == nil {
            singleton = SettingOnMap()
        }
        return singleton!
    }
    private init() {
        
    }
    public var userIsLogin: Bool {
        get {
            let loggedIn: Bool = UserDefaults.standard.bool(forKey: "loggedIn")
            return loggedIn
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "loggedIn")
        }
    }
}
