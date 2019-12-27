//


import UIKit

final class MyMessageTableViewCell: DiscussionMessageCell {
    
    @IBOutlet private weak var backView: UIView!
    @IBOutlet private weak var textMessageLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupOutlets()

        super.roundBackView()
    }
    
    func setupOutlets() {
        super.backMessageView = backView
        super.messageLabel = textMessageLabel
        super.timeSendLabel = timeLabel
    }
    
    
    
    
    
}
