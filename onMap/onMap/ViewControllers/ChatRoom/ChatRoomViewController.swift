// ChatRoomViewController.swift

import UIKit

final class ChatRoomViewController: UIViewController {
    var model: ModelChatRoom = ModelChatRoom()
    private let idCellOtherMessage = "otherMessage"
    private let idCellMyMessage = "myMessage"
    var nameOfDiscussion: String?
    var myAccountId: String = Account.shared.getID()
    private var keybordIsOpen: Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        setupSettingsView()
        
        if let name = nameOfDiscussion {
            model = ModelChatRoom(name: name)
        } else {
            // алерт о том, что чата нет или какая то ошибка
            navigationController?.popViewController(animated: true)
        }
        
        setupTableView()
        
        self.navigationItem.title = nameOfDiscussion
        
        myAccountId = Account.shared.getID()
        
        model.loadInfoForTable( { [weak self] in
            DispatchQueue.main.async {
                    self?.reloadTableView()
            }
        })
        
        
        setupKeyboardNotifications()
        
        textField.delegate = self
        
        model.setupObserver( { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }
    
    deinit {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        NotificationCenter.default.removeObserver(self)
        model.closeChatRoom()
    }
    
    func setupSettingsView() {
        self.didClickCommand((Any).self)
        
        settingsView.layer.cornerRadius = 15
        settingsView.layer.borderWidth = 1
        settingsView.layer.borderColor = UIColor.darkGray.cgColor
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
                    self.bottomTextFieldConstraint.constant = keyboardSize.height - 25
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
        if textField.text == nil || textField?.text == "" {
            return
        } else {
            model.sendMessage(owner: Account.shared.getID(), message: textField.text!)
            reloadTableView()
            textField.text = ""
        }
        
    }
    
    

    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var topTableConstraint: NSLayoutConstraint!
    var key2 = true
    @IBAction func didClickCommand(_ sender: Any) {
        if key2 {
            for _ in 0..<100 {
                UIView.animate(withDuration: 1, animations: { () -> Void in
                    self.topTableConstraint.constant -= 1
                    
                })
            }
            self.settingsView.isHidden = true
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                //self.settingsView.center.y += 100
                self.topTableConstraint.constant += 100
                self.settingsView.isHidden = false
            })
        }
        key2 = !key2
    }
    
    @IBAction func didClickSendButton(_ sender: Any) {
        sendMessage()
    }
    @IBAction func didClickDeleteButton(_ sender: Any) {
        if let name = nameOfDiscussion {
            model.deleteChat()
            //удалить из массива пинов и обновить карту
            self.navigationController?.popViewController(animated: true)
        } else {
            //алерт кинуть
            return
        }
    }
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.countMessages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = model.countMessages - indexPath.row - 1
        
        let info = model.getInfoMessage(index: index)
        
        var resultCell: MessageCell = MessageCell()
        if myAccountId == info.idOwner {
            resultCell = tableView.dequeueReusableCell(withIdentifier: idCellMyMessage) as! MyMessageTableViewCell
            resultCell.textMessage = info.message
        } else {
            resultCell = tableView.dequeueReusableCell(withIdentifier: idCellOtherMessage) as! OtherMessageTableViewCell
            resultCell.textMessage = info.message
            
            if let id = info.idOwner {
                self.model.setAvatarAndOwnerMessage(id: id, cell: resultCell)
            }
        }
        if let timeSend = info.timeSend {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: timeSend)
            let minute = calendar.component(.minute, from: timeSend)
            resultCell.textTimeSend = "\(hour):\(minute)"
        }
        
        resultCell.textMessage = info.message
        resultCell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        
        return resultCell
    }
}

extension ChatRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view.endEditing(true)
    }
}

extension ChatRoomViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}
