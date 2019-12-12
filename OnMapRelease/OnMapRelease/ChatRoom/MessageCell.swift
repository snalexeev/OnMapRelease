//
//  MessageCell.swift
//  OnMapRelease
//

import Foundation
import UIKit

protocol SetupOutletsInMessageCell {
    func setupOutlets()
}

class MessageCell: UITableViewCell {
    // свойства сообщения
    public var textMessage: String? {
        willSet (newValue) {
            messageLabel?.text = newValue
        }
    }
    public var textTimeSend: String? {
        willSet (newValue) {
            timeSendLabel?.text = newValue
        }
    }
    public var textOwner: String? {
        willSet (newValue) {
            ownerLabel?.text = textOwner
        }
    }
    public var imageAvatar: UIImage? {
        willSet (newValue) {
            theAvatar?.image = newValue
        }
    }
    //из uikit
    weak var backMessageView: UIView?
    weak var messageLabel: UILabel?
    weak var timeSendLabel: UILabel?
    weak var ownerLabel: UILabel?
    weak var theAvatar: UIImageView?
    
    internal func roundBackView() {
        backMessageView?.layer.cornerRadius = (backMessageView?.bounds.height ?? 0) / 2
        backMessageView?.layer.borderWidth = 1
        backMessageView?.layer.borderColor = backMessageView?.backgroundColor?.cgColor
        
        //backMessageView?.layer.shadowOffset = CGSize(width: 5, height: 5)
        backMessageView?.layer.shadowOpacity = 0.5
        backMessageView?.layer.shadowRadius = 2
        //backMessageView?.layer.shadow
    }
    
    internal func roundAvatarImage() {
        theAvatar?.layer.cornerRadius = (theAvatar?.bounds.height ?? 0) / 2
        theAvatar?.layer.borderWidth = 1
        theAvatar?.layer.borderColor = backMessageView?.backgroundColor?.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

typealias DiscussionMessageCell = MessageCell & SetupOutletsInMessageCell


