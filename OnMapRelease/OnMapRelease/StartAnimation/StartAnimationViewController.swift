//
//  StartAnimationViewController.swift
//  OnMapRelease
//

import UIKit
import Firebase
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
        // проверка на то, вошел ли пользователь
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil{
                self.presentLoginVC()
            }
        }
        
    }
   
    
    func presentLoginVC(){
        let storyboard = UIStoryboard.init(name: "LoginSB", bundle: nil)
        let newViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        newViewController.modalPresentationStyle = .fullScreen
        present(newViewController, animated: true, completion: nil)
        
        //        self.beginAppearanceTransition(false, animated: true)
        //        navC.beginAppearanceTransition(true, animated: true)
        //        UIView.transition(from: self.view, to: navC.view, duration: 0.5, options: [.transitionCrossDissolve]) { (_) in
        //            UIApplication.shared.delegate?.window??.rootViewController = navC
        //        }
        //        self.endAppearanceTransition()
        //        navC.endAppearanceTransition()
    }
    //    var isFlipped = true
    //    func flip(){
    //        isFlipped = !isFlipped
    //        let fromview = isFlipped ? second : scrollView
    //        let toview = isFlipped ? scrollView : second
    //        UIView.transition(from: fromview!, to: toview!, duration: 0.4, options: [UIView.AnimationOptions.curveEaseOut, UIView.AnimationOptions.transitionFlipFromLeft,UIView.AnimationOptions.showHideTransitionViews])
    //
    //    }
    
    
    
    //    override func viewWillAppear(_ animated: Bool) {
    //         Auth.auth().addStateDidChangeListener { (auth, user) in
    //            if user == nil{
    //                self.presentLoginVC()
    //            }
    //        }
    //    }
}
