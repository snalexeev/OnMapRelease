// вью для показа информации об аккаунте


import UIKit
final class AccountViewController: UIViewController {
    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    var leftInset = CGFloat()
    var leftInsetNormal = CGFloat()
    var firstFooterTitle = UITextView()
    var secondFooterTitle = UITextView()
    var nameTextField = UITextField()
    var surnameTextField = UITextField()
    var aboutTextField = UITextField()
    var exitButton = UIButton()
    var deleteButton = UIButton()
    var profileUIImageView = UIImageView()
    var changePhoneLabel = UILabel()
    var changeEmailLabel = UILabel()
    var phoneLabel = UILabel()
    var emailLabel = UILabel()
    let hideKeyboardGesture =  UITapGestureRecognizer()
    var phone = ""
    var email = ""
    var name = ""
    var surname = ""
    var status = ""
    var reuse = [true, true, true, true, true, true, true]
    
    var image = UIImage()
    let imagePicker = UIImagePickerController()
    var uploadPhotoButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = Const.accountback
        firstFooterTitle.text = "Укажите имя и, если хотите, добавьте фотографию для вашего профиля"
        secondFooterTitle.text = "Любые подробности, например, возраст, род занятий или город.\nПример: 23 года, дизайнер из Санкт-Петербурга"
        leftInset = view.frame.width/4
        let cell = UITableViewCell()
        leftInsetNormal = 6*cell.frame.size.height/11
        self.view.addSubview(self.tableView)
        self.tableView.register(AccountTableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.updateLayout(with: self.view.frame.size)
        hideKeyboardGesture.addTarget(self, action: #selector(hideKeyboard))

        Account.shared.accountDelegate = self
        name = Account.shared.getName()
        surname = Account.shared.getSurname()
        phone = Account.shared.getPhone()
        email = Account.shared.getEmail()
        status = Account.shared.getStatus()
        profileUIImageView.image = Account.shared.getPhoto()
        PhotoNetworking.shared.resultDelegate = self
        image = UIImage(named: "1.png")!
        setupPhotoExtension()
        
    
    }

//    @IBAction func save(_ sender: Any) {
//        Account.shared.setUserInfo(name: nameTextField.text!, surname: surnameTextField.text!)
//        isNotEditing(state: true)
//        self.textUsernameLabel.text! = Account.shared.getName()
//        self.secondNameLabel.text! = Account.shared.getSurname()
//        barButton.title = editStr
//    }
    func showConfirmation(){
        let storyboard = UIStoryboard(name: "Confirmation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfirmationViewController") as! ConfirmationViewController
        present(vc, animated: true)
    }
    func presentLoginViewController() {
        let vc = UIStoryboard(name: "LoginViewController", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //let nc = UINavigationController.init(rootViewController: vc)
        vc.modalPresentationStyle = .fullScreen
        if Const.didAppearLogin{
            dismiss(animated: false, completion: nil)
        }
        else{
            present(vc, animated: false)
        }
    }
   
    func reloadTable(){
        self.reuse = [true, true, true, true, true, true, true]
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    @objc func exit(){
        SettingOnMap.shared.currentuserID = ""
        presentLoginViewController()
    }
    @objc func deleteAccount(){
        showConfirmation()
    }
    func changeNumber(){
        let vc = UIStoryboard(name: "ChangePhoneViewController", bundle: nil).instantiateViewController(withIdentifier: "ChangePhoneViewController") as! ChangePhoneViewController
        navigationController?.pushViewController(vc, animated: true)
        reloadTable()
        
    }
    func changeEmail(){
        print("changeEmail")
        reloadTable()
    }
    func changeName(){
        name = nameTextField.text ?? ""
        DispatchQueue.main.async {
            Account.shared.setUserName(name: self.name)
        }
        reloadTable()
    }
    func changeSurname(){
        surname = surnameTextField.text ?? ""
        DispatchQueue.main.async {
            Account.shared.setUserSurname(surname: self.surname)
        }
        reloadTable()
    }
    func changeStatus(){
        status = aboutTextField.text ?? ""
        DispatchQueue.main.async {
            Account.shared.setUserStatus(status: self.status)
        }
        reloadTable()
    }

    
    @objc func hideKeyboard(){
        tableView.endEditing(true)
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
        self.profileUIImageView.image = image
        self.reloadTable()
    }
    
    func setFields(name: String, surname: String, phone: String, email: String, status: String) {
        self.name = name
        self.surname = surname
        self.phone = phone
        self.email = email
        self.status = status
        self.reloadTable()
    }
  
}
