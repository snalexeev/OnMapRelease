//
//  SettingsOnMap.swift
//  onMap
//

import Foundation
import MapKit

class SettingOnMap {
    private static var singleton: SettingOnMap?
    public static var shared: SettingOnMap {
        if singleton == nil {
            singleton = SettingOnMap()
        }
        return singleton!
    }
    private init() {
        mapType = .standard
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
    private var map: MKMapView?
    public func setMap(map: MKMapView) {
        self.map = map
    }
    public var mapType: MKMapType {
        willSet (newValue) {
            map?.mapType = newValue
            //сохранить в userDefaults
        }
    }
}
