//
//  MapModel.swift
//  onMap


// model for MapViewController
import Foundation

final class MapModel {
    public var annotationsArray: [PinChat]
    public init() {
        annotationsArray = [PinChat]()
        
        // загрузка всех чатов и их генерация
    }
}
