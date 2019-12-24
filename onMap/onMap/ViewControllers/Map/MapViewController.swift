//
//  MapViewController.swift
//  onMap
//

import UIKit
import MapKit
import FirebaseAuth
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        sendCode()
        SettingOnMap.shared.setMap(map: mapView)
        //SettingOnMap.shared.mapType = .hybrid
        
    }
    func sendCode(){
           let phoneNumber  = "+79961008307"
           //PhoneAuthProvider.provider(auth: Auth.auth())
           //Auth.auth().settings?.isAppVerificationDisabledForTesting = true
           PhoneAuthProvider.provider(auth: Auth.auth()).verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
               if let error = error {
                 print(error.localizedDescription)
                 return
               }
        }
    }

}
