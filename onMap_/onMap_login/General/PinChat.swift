// структура для создания ярлыков чатов на карте


import Foundation
import MapKit

class PinChat: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    //let discipline: String
    let coordinate: CLLocationCoordinate2D
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D) {
       self.title = title
       self.locationName = locationName
       //self.discipline = discipline
       self.coordinate = coordinate
       
       super.init()
    }
    
    var subtitle: String? {
      return locationName
    }
}

