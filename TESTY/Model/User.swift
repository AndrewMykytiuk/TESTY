//
//  User.swift
//  TESTY
//
//  Created by User on 07/04/2018.
//  Copyright © 2018 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import RealmSwift
import Realm

class User:Object {
    
    @objc dynamic var name:String = ""
    @objc dynamic var phone:String = ""
    @objc dynamic var mail:String = ""
    @objc dynamic var image:Data? = nil
    
}
