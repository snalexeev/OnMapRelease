//
//  MapViewController.swift
//  onMap


import UIKit
import MapKit
import CoreLocation

final class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var theMessenger: MessengerOnMap = FirestoreMessenger.shared

    var annotationsArray: [MKAnnotation] = [MKAnnotation]() {
        didSet (oldValue) {
             //для удаление с map при удалении из массива
            if oldValue.count > self.annotationsArray.count {
                for i in 0..<annotationsArray.count {
                    if oldValue[i].title != self.annotationsArray[i].title {
                        mapView.removeAnnotation(oldValue[i])
                        break
                    }
                }
                mapView.removeAnnotation(oldValue[oldValue.count - 1])
            }
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // скрытие навигатион контроллера
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        checkLocationAuthorizationStatus()
        
        setupMap()
        let initialLocation = CLLocation(latitude: 55.766, longitude: 37.684)
        let regionRadius: CLLocationDistance = 1000
        func centerMapOnLocation(location: CLLocation) {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
          mapView.setRegion(coordinateRegion, animated: true)
        }
        
        centerMapOnLocation(location: initialLocation)
        
        theMessenger.loadChatInfoArray {
            self.setupAnotations()
        }
        
        theMessenger.setupObserverChats {
            self.setupAnotations()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func setupMap() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        //mapView.showsUserLocation = true
    }
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mapView.showsUserLocation = false
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func setupAnotations() {
        annotationsArray.removeAll()
        mapView.removeAnnotations(mapView.annotations)
        let size = theMessenger.numberOfChats
        for i in 0..<size {
            let info = theMessenger.getInfoAboutChat(index: i)
            let pin = PinChat(title: info.name, locationName: "беседа", coordinate: CLLocationCoordinate2D(latitude: info.xCoordinate, longitude: info.yCoordinate))
            annotationsArray.append(pin)
            self.mapView.addAnnotation(pin)
        }
    //        DispatchQueue.main.async {
    //            self.mapView.addAnnotations(self.annotationsArray)
    //        }
        }

    @IBAction func didLongPressMap(_ sender: Any) {
        let pressPoint = (sender as AnyObject).location(in: mapView)
                let pressCoordinate = mapView.convert(pressPoint, toCoordinateFrom: mapView)
               
                let composeAlert = UIAlertController(title: "New chatroom", message: "Enter name of chat", preferredStyle: .alert)
                composeAlert.addTextField { (textField: UITextField) in
                    textField.placeholder = "Name of chat"
                }
                
                composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                composeAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action: UIAlertAction) in
                    if let name = composeAlert.textFields?.first?.text {
                        if (self.theMessenger.addChat(nameDiscussion: name, xCoordinate: pressCoordinate.latitude, yCoordinate: pressCoordinate.longitude)) {
        //                    let pressPin = PinChat(title: name, locationName: "DiscussionRoom", coordinate: pressCoordinate)
        //                    self.mapView.addAnnotation(pressPin)
                            let pin = PinChat.init(title: name, locationName: "", coordinate: pressCoordinate)
//                            pin.coordinate = pressCoordinate
//                            pin.title = name
                            //pin.imageName = #imageLiteral(resourceName: "thePinImage")
                            self.mapView.addAnnotation(pin)
                        } else {
                            //вызвать алерт с ошибкой
                        }
                    }
                                   
                }))
                self.present(composeAlert, animated: true, completion: nil)
    }
}

extension MapViewController: CLLocationManagerDelegate {
}



extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//       let reuseIdentifier = "pin"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//
//        //annotationView?.detailCalloutAccessoryView =
//        let test = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 20))
//        test.text = annotation.title!
//
//        test.textColor = .systemBlue
//        
//        test.textAlignment = .center
//
//        test.layer.cornerRadius = (test.bounds.height ) / 2
//        test.layer.borderWidth = 1
//        test.layer.borderColor = test.backgroundColor?.cgColor
//
//        let image = UIImage.imageWithLabel(test)
//
//        annotationView?.image = image
//
//        return annotationView
//    }
    
    func displayAlert(message: String, action: String) {
        let composeAlert = UIAlertController(title: "Ошибочка!", message: message, preferredStyle: .alert)
        composeAlert.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))
        self.present(composeAlert, animated: true, completion: nil)
    }
    
    func presentDuscussionViewController(name: String?) {
        guard let name = name else {
            return
        }
        let storyboard = UIStoryboard.init(name: "ChatRoomViewController", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        newViewController.theMessenger = theMessenger
        newViewController.nameOfDiscussion = name
        //theMessenger.startDiscussRoom(name: name)
        newViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let name = view.annotation?.title {
            if theMessenger.chatIsExist(name: name!) {
                
                presentDuscussionViewController(name: name)
            } else {
                displayAlert(message: "Упс, в чат войти не удалось", action: "cancel")
                if let pin = view.annotation {
                    mapView.removeAnnotation(pin)
                }
            }
        }
    
        //view.canShowCallout = false
        
        //view.isSelected = false
        return
    }
}


extension UIImage {
    class func imageWithLabel(_ label: UILabel) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
