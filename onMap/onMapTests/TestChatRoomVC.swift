//
//  TestChatRoomVC.swift
//  onMapTests
//
//  Created by Sergei Alexeev on 14.01.2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import UIKit
@testable import onMap


final class TestChatRoomVC {
    var vc: ChatRoomViewController
    init() {
        vc = UIStoryboard(name: "ChatRoomViewController", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomViewController") as! ChatRoomViewController
        vc.model.bd = MessengerMock.shared
    }
    
    func testSend() -> Bool {
        vc.viewDidLoad()
        vc.textField.text = "testMessage"
        let n1 = vc.model.countMessages
        vc.sendMessage()
        let n2 = vc.model.countMessages
        return (n2 == n1 + 1)
    }
}
