//
//  People.swift
//  onMap
//
//  Created by Екатерина on 12/01/2020.
//  Copyright © 2020 onMap. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
class Person: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var image = UIImage()
    
}
