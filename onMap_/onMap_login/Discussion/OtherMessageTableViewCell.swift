//


import UIKit

final class OtherMessageTableViewCell: DiscussionMessageCell {

    @IBOutlet weak var theAvatarImage: UIImageView!
    @IBOutlet weak var textMessageLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupOutlets()
        roundBackView()
        roundAvatarImage()
    }
        
    func setupOutlets() {
        super.messageLabel = textMessageLabel
        super.backMessageView = backView
        super.theAvatar = theAvatarImage
        //super.imageAvatar = #imageLiteral(resourceName: "thePinImage")
        super.timeSendLabel = timeLabel
        //owner
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupBackView() {
        backView.layer.cornerRadius = 8//backView.bounds.height / 2
        backView.layer.borderWidth = 1
        backView.layer.borderColor = backView.backgroundColor?.cgColor
    }
    
    func setupAvatarImage() {
        theAvatarImage.layer.cornerRadius = backView.bounds.height / 2
        theAvatarImage.layer.borderWidth = 1
        theAvatarImage.layer.borderColor = backView.backgroundColor?.cgColor
    }
    
}
