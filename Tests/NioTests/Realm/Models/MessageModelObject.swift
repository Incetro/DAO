//
//  MessageModelObject.swift
//  Nio
//
//  Created by incetro on 07/10/2019.
//

import Nio

// MARK: - MessageModelObject

class MessageModelObject: RealmModel {

    @objc dynamic var date = Date()
    @objc dynamic var text = ""
    @objc dynamic var receiverId = 0
    @objc dynamic var senderId = 0
    @objc dynamic var type = 0
    @objc dynamic var isIncoming = false
    @objc dynamic var isRead = false
}
