//

import UIKit

final class DiscussionRoomViewController: UIViewController {
    var theMessenger: MessengerOnMap?
    let idCellOtherMessage = "otherMessage"
    let idCellMyMessage = "myMessage"
    var nameOfDiscussion: String?
    var myAccountId: String?
    var keybordIsOpen: Bool = false
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        myAccountId = Account.shared.getID()
        
        theMessenger?.loadDiscussionRoom( { [weak self] in
            self?.reloadTableView()
        })
        
        setupKeyboardNotifications()
        
        textField.delegate = self
        
        theMessenger?.setupObserverChatRoom({
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        theMessenger?.closeDiscussRoom()
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
               UIView.animate(withDuration: 0.1, animations: { () -> Void in
                if self.keybordIsOpen == false {
                    self.keybordIsOpen = true
                    self.bottomTextFieldConstraint.constant = keyboardSize.height + 25
                    self.view.layoutIfNeeded()
                }
                   
            })
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            if self.keybordIsOpen == true {
                self.keybordIsOpen = false
                self.bottomTextFieldConstraint.constant = 25
                self.view.layoutIfNeeded()
            }
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = self.view.backgroundColor
        tableView.estimatedRowHeight = UITableView.automaticDimension + 20
        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        tableView.register(UINib(nibName: "OtherMessageTableViewCell", bundle: nil), forCellReuseIdentifier: idCellOtherMessage)
        tableView.register(UINib(nibName: "MyMessageTableViewCell", bundle: nil), forCellReuseIdentifier: idCellMyMessage)
    }
    
    func closeViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func sendMessage() {
        if textField.text == nil && textField?.text == "" {
            return
        }
        theMessenger?.sendMessage(owner: Account.shared.getID(),
                                  message: textField.text!)
        reloadTableView()
        textField.text = ""
    }
    

    
    @IBAction func didClickDeleteButton(_ sender: Any) {
        if let name = nameOfDiscussion {
            theMessenger?.deleteChat(name: name)
            //удалить из массива пинов и обновить карту
            closeViewController()
        } else {
            //алерт кинуть
            return
        }
        
    }
    
    @IBAction func didClickBackButton(_ sender: Any) {
        theMessenger?.closeDiscussRoom()
        closeViewController()
    }
    
    @IBAction func didClickSendButton(_ sender: Any) {
        sendMessage()
    }
}

extension DiscussionRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theMessenger?.countMessages ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = 0
        if let size = theMessenger?.countMessages {
            index = size - indexPath.row - 1
        }
        
        let info = theMessenger?.getInfoAboutMessage(index: index)
        
        var resultCell: MessageCell?
        if myAccountId == info?.idOwner {
            resultCell = tableView.dequeueReusableCell(withIdentifier: idCellMyMessage) as! MyMessageTableViewCell
            resultCell?.textMessage = info?.message
        } else {
            resultCell = tableView.dequeueReusableCell(withIdentifier: idCellOtherMessage) as! OtherMessageTableViewCell
            
//            Account.shared.loadPhotoByID(userID: (info?.idOwner)!) { (photo) in
//               DispatchQueue.main.async {
//                   resultCell?.imageAvatar = photo
//               }
//           }
            resultCell?.textMessage = info?.message
//            Account.shared.loadTextDataByID(userID: (info?.idOwner)!) { (name, surname) in
//                DispatchQueue.main.async {
//                    print(name + surname)
//                    //resultCell?.textMessage = name + " " + surname + (strMessage ?? "")
//                }
//            }
        }
        if let timeSend = info?.timeSend {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: timeSend)
            let minute = calendar.component(.minute, from: timeSend)
            resultCell?.textTimeSend = "\(hour):\(minute)"
        }
        
        resultCell?.textMessage = info?.message
        resultCell?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return resultCell ?? UITableViewCell.init()
    }
}

extension DiscussionRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension DiscussionRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
