//
//  StartAnimationViewController.swift
//  OnMapRelease
//

import UIKit

class StartAnimationViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scaleDuration: TimeInterval = 0.7
        //let delay: TimeInterval = 1.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() /*+ delay*/) {
            UIView.animate(withDuration: scaleDuration) {
                self.logoImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
        }
    }
}
