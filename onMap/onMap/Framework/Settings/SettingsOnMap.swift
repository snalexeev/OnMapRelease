//
//  SettingsOnMap.swift
//  onMap
//

import Foundation

final class SettingOnMap {
    private static var singleton: SettingOnMap?
    public static var shared: SettingOnMap {
        if singleton == nil {
            singleton = SettingOnMap()
        }
        return singleton!
    }
    private init() { }
    public var currentuserID: String {
        get {
            let loggedIn: String = UserDefaults.standard.string(forKey: "loggedIn") ?? ""
            return loggedIn
        }
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: "loggedIn")
        }
    }
}
