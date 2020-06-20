//
//  DialogModelObject.swift
//  DAO
//
//  Created by incetro on 07/10/2019.
//

import DAO
import RealmSwift

// MARK: - DialogModelObject

class DialogModelObject: RealmModel {
    
    @objc dynamic var isPinned = false
    let messages = List<MessageModelObject>()
}
