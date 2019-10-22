//
//  UserModelObject.swift
//  Nio
//
//  Created by incetro on 26/08/2018.
//

import Nio
import RealmSwift

// MARK: - UserModelObject

class UserModelObject: RealmModel {
    
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    let dialogs = List<DialogModelObject>()
}
