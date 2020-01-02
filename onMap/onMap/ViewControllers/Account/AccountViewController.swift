// вью для показа информации об аккаунте


import UIKit
final class AccountViewController: UIViewController {
    
// @IBOutlet weak var testPhoto: UIImageView!
//
//@IBOutlet weak var test: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var textUsernameLabel: UILabel!
    
    @IBOutlet weak var secondNameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var surnameTextField: UITextField!
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var editStr = "редактировать"
    var cancelStr = "отменить"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        loadTest()
        barButton.title = editStr
        isNotEditing(state: true)
        Account.shared.accountDelegate = self
        if Account.shared.getName() == ""{
            Account.shared.accountDelegate = self
            Account.shared.loadData()
        }
        self.textUsernameLabel.text! = Account.shared.getName()
        self.secondNameLabel.text! = Account.shared.getSurname()
        self.phoneLabel.text! = Account.shared.getPhone()
        self.emailLabel.text! = Account.shared.getEmail()
        self.profileImageView.image = Account.shared.getPhoto()
    
    }
    //пример использования функции
//    func loadTest(){
//        var id = Auth.auth().currentUser!.uid
//        print(id)
//        Account.shared.loadTextDataByID(userID: id) { (name, surname) in
//            DispatchQueue.main.async {
//                self.test.text! = name + surname
//            }
//        }
//        Account.shared.loadPhotoByID(userID: id) { (photo) in
//            DispatchQueue.main.async {
//                self.testPhoto.image! = photo
//            }
//
//        }
//    }
    
    @IBAction func save(_ sender: Any) {
        Account.shared.setUserInfo(name: nameTextField.text!, surname: surnameTextField.text!)
        isNotEditing(state: true)
        self.textUsernameLabel.text! = Account.shared.getName()
        self.secondNameLabel.text! = Account.shared.getSurname()
        barButton.title = editStr
    }
    
    
    func isNotEditing(state: Bool){
        if !state{
            nameTextField.text! = textUsernameLabel.text!
            surnameTextField.text! = secondNameLabel.text!
        }
        textUsernameLabel.isHidden = !state
        textUsernameLabel.isEnabled = state
        
        secondNameLabel.isHidden = !state
        secondNameLabel.isEnabled = state
        
        nameTextField.isHidden = state
        nameTextField.isEnabled = !state
    
        surnameTextField.isHidden = state
        surnameTextField.isEnabled = !state
        
        saveButton.isHidden = state
        saveButton.isEnabled = !state
    }
    
    @IBAction func edit(_ sender: Any) {
        if barButton.title == editStr{
            barButton.title = cancelStr
            isNotEditing(state: false)
        }
        else{
            barButton.title = editStr
            isNotEditing(state: true)
        }
    }
    
    @IBAction func deleteAccount(_ sender: Any) {
        showConfirmation()
    }
    func showConfirmation(){
        let storyboard = UIStoryboard(name: "Confirmation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
        present(vc, animated: true)
    }
    func presentLoginViewController() {
        let vc = UIStoryboard(name: "LoginViewController", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //let nc = UINavigationController.init(rootViewController: vc)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }
   
    @IBAction func LogOut(_ sender: Any) {
        SettingOnMap.shared.currentuserID = ""
        presentLoginViewController()
    }

}
extension AccountViewController: AccountDelegate{
    func showError(title: String, message: String, status: Bool) {
        if status{
           presentLoginViewController()
        }
        else{
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setImage(image: UIImage?) {
        profileImageView.image = image
    }
    
    func setFields(name: String, surname: String, phone: String, email: String) {
        self.textUsernameLabel.text! = name
        self.secondNameLabel.text! = surname
        self.phoneLabel.text! = phone
        self.emailLabel.text! = email
    }
  
}
