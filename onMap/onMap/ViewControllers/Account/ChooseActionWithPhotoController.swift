//
//  ChooseActionWithPhotoController.swift
//  onMap
//
//  Created by Екатерина on 09/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import UIKit
protocol ChooseSourceDelegate {
    func chosenSource(s: Character)
}
class ChooseActionWithPhotoController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var chosenDelegate: ChooseSourceDelegate?
    var tvY = CGFloat()
    let tableView = UITableView()
    var uploadFromLibraryButton = UIButton()
    var takePhotoButton = UIButton()
    var cancelButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.grayAlpha
        tableView.bounces = false
        tableView.backgroundColor = Const.transp
        let cell = UITableViewCell()
        print(cell.bounds.height)
        tvY = view.bounds.maxY - 4*cell.bounds.height
        tableView.frame = CGRect(x: 0, y:tvY, width: view.frame.width, height: view.frame.height - tvY)
        self.view.addSubview(self.tableView)
        self.tableView.register(ChooseTableViewCell.self, forCellReuseIdentifier: "ChooseTableViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.updateLayout(with: self.view.frame.size)
        // Do any additional setup after loading the view.
    }
    func updateLayout(with size: CGSize) {
        self.tableView.frame = CGRect(x: 0, y:tvY, width: view.frame.width, height: view.frame.height - tvY)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
       super.viewWillTransition(to: size, with: coordinator)
       coordinator.animate(alongsideTransition: { (contex) in
          self.updateLayout(with: size)
       }, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           switch section {
           case 0:
               return 3
            default:
              return 0
           }
       }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ChooseTableViewCell", for: indexPath) as! ChooseTableViewCell
        cell.backgroundColor = Const.transp
        switch indexPath.row {
        case 0:
            cell.setupUploadFromLibraryButton(viewWidth: view.frame.width)
            uploadFromLibraryButton = cell.uploadFromLibraryButton
            uploadFromLibraryButton.addTarget(self, action: #selector(uploadFromLibrary), for: .touchUpInside)
            cell.addSubview(uploadFromLibraryButton)
        case 1:
            cell.setupTakePhotoButton(viewWidth: view.frame.width)
            takePhotoButton = cell.takePhotoButton
            takePhotoButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
            cell.addSubview(takePhotoButton)
        case 2:
            cell.setupCancelButton(viewWidth: view.frame.width)
            cancelButton = cell.cancelButton
            cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            cell.addSubview(cancelButton)
        default:
            break
        }
        return cell

    }
    @objc func cancel(){
        self.dismiss(animated: true, completion: {
            self.chosenDelegate?.chosenSource(s: "c")
        })
    }
    @objc func uploadFromLibrary(){
    
        self.dismiss(animated: true, completion: {
             self.chosenDelegate?.chosenSource(s: "l")
        })
    }
    @objc func takePhoto(){
        self.dismiss(animated: true, completion: {
             self.chosenDelegate?.chosenSource(s: "t")
        })
    }

   
}
class ChooseTableViewCell: UITableViewCell{
    var uploadFromLibraryButton = UIButton()
    var takePhotoButton = UIButton()
    var cancelButton = UIButton()
    func setupCancelButton(viewWidth: CGFloat){
        cancelButton.setUpAccountButton(text: "Cancel", colorText: .systemRed, colorBack: Const.accountback, textSize: self.frame.size.height/2, y: self.bounds.minY, width: viewWidth, height: self.frame.size.height)
    }
    func setupUploadFromLibraryButton(viewWidth: CGFloat){
        uploadFromLibraryButton.setUpAccountButton(text: "Upload from library", colorText: Const.accountText, colorBack: Const.accountback, textSize: self.frame.size.height/2, y: self.bounds.minY, width: viewWidth, height: self.frame.size.height)
    }
    func setupTakePhotoButton(viewWidth: CGFloat){
        takePhotoButton.setUpAccountButton(text: "Take photo", colorText: Const.accountText, colorBack: Const.accountback, textSize: self.frame.size.height/2, y: self.bounds.minY, width: viewWidth, height: self.frame.size.height)
    }
    
    
}
