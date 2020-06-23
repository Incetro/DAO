//
//  UserModelObject.swift
//  SDAO
//
//  Created by incetro on 26/08/2018.
//

import SDAO
import RealmSwift

// MARK: - UserModelObject

final class UserModelObject: RealmModel {

    /// User's name
    @objc dynamic var name: String = ""

    /// User's age
    @objc dynamic var age: Int = 0

    /// User's dialogs
    let dialogs = List<DialogModelObject>()
}
