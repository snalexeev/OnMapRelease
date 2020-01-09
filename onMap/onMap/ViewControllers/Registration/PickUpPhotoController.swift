//

import UIKit

class PickUpPhotoController: UIViewController {
   
    @IBOutlet weak var imageView: UIImageView!
    var image = UIImage()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoNetworking.shared.resultDelegate = self
        image = imageView.image!
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getPhoto(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        image = info[.originalImage] as! UIImage
        imageView.image = image
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadPhoto(_ sender: Any) {
        PhotoNetworking.shared.uploadPhoto(image: image)
    }
    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
extension PickUpPhotoController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension PickUpPhotoController: PhotoUploadResultDelegate{
    func showAlert(title: String, message: String) {
        showError(title: title, message: message)
    }
    
    func completed() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
