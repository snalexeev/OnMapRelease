//
//  ConstantsWithAnimations.swift
//  onMap
//
//  Created by Екатерина on 02/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import Foundation
import UIKit
final class Const{
    static let themeColor = UIColor(named: "loginTheme") ?? UIColor.white
    static let mainBlueColor = UIColor(named: "mainBlueColor") ?? UIColor(red: (74/255.0), green: (91/255.0), blue: (250/255.0), alpha: 1.0)
    static let accountback = UIColor(named: "AccountBackground") ?? UIColor.white
    static let accountElements = UIColor(named: "AccountElements")
    static let accountText = UIColor(named: "AccountText") ?? UIColor.gray
    static let accountTextTransp = UIColor(named: "AccountTextTransp") ?? UIColor.gray
    static let transp = UIColor(red: (0/255.0), green: (0/255.0), blue: (0/255.0), alpha: 0)
     static let secondBlueColor = UIColor(named: "secondBlueColor") ?? UIColor(red: (42/255.0), green: (0/255.0), blue: (178/255.0), alpha: 1.0)
    static let gray = UIColor(red: (64/255.0), green: (64/255.0), blue: (64/255.0), alpha: 1.0)
    static let grayAlpha = UIColor(red: (64/255.0), green: (64/255.0), blue: (64/255.0), alpha: 0.1)
    static let green = UIColor(named: "green") ?? UIColor(red: (20/255.0), green: (201/255.0), blue: (114/255.0), alpha: 1.0)
    static let transpGray = UIColor(red: (242/255.0), green: (242/255.0), blue: (247/255.0), alpha: 0.5)
    static let lightGray = UIColor.lightGray
    static let logoName = "logoOnMap1"
    static let fontName = "LazyTypebeta"
    static var didAppearLogin = false
    static var source = "c"
    static var updateDelete = false
    static var updatePhoneEmail = false
}
