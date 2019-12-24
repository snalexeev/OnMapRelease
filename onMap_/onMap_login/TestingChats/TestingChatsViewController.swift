//


import UIKit

class TestingChatsViewController: UIViewController {
    static let idCell = "infoChatCell"
    var theMessenger: MessengerOnMap?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        theMessenger?.setupObserverChats({
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        loadDataAndReloadTable()
        
    }
    
    func loadDataAndReloadTable() {
        theMessenger?.loadChatInfoArray( { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        })
    }

    
    @IBAction func didClickCompose(_ sender: Any) {
        let composeAlert = UIAlertController(title: "New chatroom", message: "Enter name of chat", preferredStyle: .alert)
        composeAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "Name of chat"
        }
        composeAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "x"
        }
        composeAlert.addTextField { (textField: UITextField) in
            textField.placeholder = "y"
        }
        composeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        composeAlert.addAction(UIAlertAction(title: "Send", style: .default, handler: { (action: UIAlertAction) in
            if
                let name = composeAlert.textFields?.first?.text,
                let yCoordinate = composeAlert.textFields?.last?.text,
                let xCoordinate = composeAlert.textFields?[1].text {
                if (self.theMessenger?.addChat(nameDiscussion: name, xCoordinate: Double(xCoordinate)!, yCoordinate: Double(yCoordinate)!) ?? false) {
                    self.loadDataAndReloadTable()
                } else {
                    //вызвать алерт с ошибкой
                }
            }
                           
        }))
        self.present(composeAlert, animated: true, completion: nil)
    }
    
    func presentDiscussionRoomViewController(index: Int, nameDiscussion: String?, idDiscussion: String?) {
        let storyboard = UIStoryboard.init(name: "DiscussionRoom", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "DiscussionRoomViewController") as! DiscussionRoomViewController
        newViewController.theMessenger = theMessenger
        //theMessenger?.loadDiscussionRoom(chatLink: idDiscussion!, nil)
        newViewController.nameOfDiscussion = nameDiscussion
        //newViewController.idDiscussion = idDiscussion
        newViewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(newViewController, animated: true)
    }
    @IBAction func didClickBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


extension TestingChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let info = theMessenger?.getInfoAboutChat(index: index)
        let name = info?.name
        let id = info?.idDiscussion
        presentDiscussionRoomViewController(index: index, nameDiscussion: name, idDiscussion: id)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let kek = Account.shared.getID()
        return "\(kek)"
    }
}

extension TestingChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theMessenger?.numberOfChats ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let theInfo = theMessenger?.getInfoAboutChat(index: indexPath.row)
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "test")
        cell.textLabel?.text = theInfo?.name
        cell.detailTextLabel?.text = theInfo?.timeCreate.description
        //cell!.imageView?.image = #imageLiteral(resourceName: "test")
        return cell
    }
    
    
}
