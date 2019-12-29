//


import UIKit
import Firebase
class ResetPasswordVC: UIViewController {

    @IBOutlet weak var login: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func reset(_ sender: Any) {
        let email = login.text!
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
