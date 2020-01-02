//
//  CustomAnimations.swift
//  onMap
//
//  Created by Екатерина on 02/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import UIKit
final class Custom: UIView {
    override func draw(_ rect: CGRect) {backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        let width = bounds.width/1.2
        let height = bounds.height/2.2
        let pathRect = CGRect(x: bounds.width / 2 - width/2, y: bounds.height - height, width: width, height: height)
        let path = UIBezierPath(roundedRect: pathRect, cornerRadius: width/8)
        Const.themeColor.setFill()
        path.fill()
        //UIColor.black.setStroke()
        //path.lineWidth = 1
        //path.stroke()
        
    }
    func animateUp(delta: CGFloat, delay: TimeInterval, duration: TimeInterval){
        let textAnimationDuration: TimeInterval = duration
        let delay = delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
           UIView.animate(withDuration: textAnimationDuration) {
            self.center.y -= delta
            self.alpha = 1
            }
        }
    }
    func animateDown(delta: CGFloat, delay: TimeInterval, duration: TimeInterval){
        let textAnimationDuration: TimeInterval = duration
        let delay = delay
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
           UIView.animate(withDuration: textAnimationDuration) {
            self.center.y += delta
            self.alpha = 1
            }
        }
        self.updateConstraints()
    }

}


final class Gradient: UIView {
    override func draw(_ rect: CGRect) {
    // gradient
        let context = UIGraphicsGetCurrentContext()
        var startColor: UIColor
        var endColor: UIColor
        startColor = Const.mainBlueColor
        endColor = Const.secondBlueColor

        

        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocations: [CGFloat] = [0, 1]

        guard let gradient = CGGradient(colorsSpace: colorSpace,
                                        colors: colors as CFArray,
                                        locations: colorLocations) else {
                                            return
        }

        let startPoint = CGPoint(x: bounds.width/2, y: 0)
        let endPoint = CGPoint(x: bounds.width/2, y: bounds.height)

        context?.drawLinearGradient(gradient,
                                    start: startPoint,
                                    end: endPoint,
                                    options: [])
    
    }
}
