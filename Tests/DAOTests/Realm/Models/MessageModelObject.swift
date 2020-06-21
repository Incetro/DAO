//
//  MessageModelObject.swift
//  DAO
//
//  Created by incetro on 07/10/2019.
//

import DAO
import Foundation

// MARK: - MessageModelObject

final class MessageModelObject: RealmModel {

    /// Sending date
    @objc dynamic var date = Date()

    /// Message text
    @objc dynamic var text = ""

    /// Receiver's id
    @objc dynamic var receiverId = 0

    /// Sender's id
    @objc dynamic var senderId = 0

    /// Message type
    @objc dynamic var type = 0

    /// True if the message is incoming
    @objc dynamic var isIncoming = false

    /// True if the message has been read
    @objc dynamic var isRead = false
}
