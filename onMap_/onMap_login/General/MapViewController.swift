// view for map

import UIKit
import MapKit
import CoreLocation
import Firebase

final class MapViewController: UIViewController {
    var textUsername = ""
    var theMessenger: MessengerOnMap = FirestoreMessenger()
    var annotationsArray: [MKAnnotation] = [MKAnnotation]() {
        didSet (oldValue) {
             //для удаление с map при удалении из массива
            if oldValue.count > self.annotationsArray.count {
                for i in 0..<annotationsArray.count {
                    if oldValue[i].title != self.annotationsArray[i].title {
                        mapView.removeAnnotation(oldValue[i])
                        print(oldValue[i].title)
                        break
                    }
                }
                mapView.removeAnnotation(oldValue[oldValue.count - 1])
                print(oldValue[oldValue.count - 1].title)
            }
        }
    }
    
    @IBAction func kek(_ sender: Any) {
        guard annotationsArray.count != 0 else { return }
        annotationsArray.remove(at: annotationsArray.count - 1)
    }
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Account.shared.loadData()   //загрузка всей информации профиля
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
    
    func setupMap() {
        mapView.delegate = self
        mapView.mapType = .standard
    }
    
    func setupAnotations() {
        annotationsArray.removeAll()
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
    
    func presentDuscussionViewController(name: String?) {
        guard let name = name else {
            return
        }
        let storyboard = UIStoryboard.init(name: "DiscussionRoom", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "DiscussionRoomViewController") as! DiscussionRoomViewController
        newViewController.theMessenger = theMessenger
        newViewController.nameOfDiscussion = name
        theMessenger.startDiscussRoom(name: name)
        newViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    @IBAction func logOut(_ sender: Any) {
        do {
            try
            Auth.auth().signOut()
            dismiss(animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
    func presentAccountViewController() {
        let storyboard = UIStoryboard(name: "AccountViewController", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
        newViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(newViewController, animated: true)
        
    }
    
    func displayAlert(message: String, action: String) {
        let composeAlert = UIAlertController(title: "Ошибочка!", message: message, preferredStyle: .alert)
        composeAlert.addAction(UIAlertAction(title: action, style: .cancel, handler: nil))
        self.present(composeAlert, animated: true, completion: nil)
    }
    
    @IBAction func didCkickTest(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "TestChats", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "TestingChatsViewController") as! TestingChatsViewController
        newViewController.theMessenger = theMessenger
        newViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(newViewController, animated: true)
    }

    @IBAction func didClickBarAccountButton(_ sender: Any) {
        self.presentAccountViewController()
    }
    
    @IBAction func didLongPressMap(_ sender: UILongPressGestureRecognizer) {
        let pressPoint = sender.location(in: mapView)
        let pressCoordinate = mapView.convert(pressPoint, toCoordinateFrom: mapView)
       
        let composeAlert = UIAlertController(title: "New chatroom", message: "Enter name of chat", preferredStyle: .alert)
        composeAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Name of chat"
        }
        
        composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        composeAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action: UIAlertAction) in
            if let name = composeAlert.textFields?.first?.text {
                if (self.theMessenger.addChat(nameDiscussion: name, xCoordinate: pressCoordinate.latitude, yCoordinate: pressCoordinate.longitude)) {
                    let pressPin = PinChat(title: name, locationName: "DiscussionRoom", coordinate: pressCoordinate)
                    self.mapView.addAnnotation(pressPin)
                } else {
                    //вызвать алерт с ошибкой
                }
            }
                           
        }))
        self.present(composeAlert, animated: true, completion: nil)
    }
    
    
}

extension MapViewController: MKMapViewDelegate {
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
        return
    }
}

extension MapViewController: CLLocationManagerDelegate {
    
}
