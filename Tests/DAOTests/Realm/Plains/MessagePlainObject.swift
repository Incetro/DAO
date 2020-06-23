//
//  MessagePlainObject.swift
//  SDAO
//
//  Created by incetro on 07/10/2019.
//

import SDAO
import Foundation

// MARK: - MessagePlainObject

struct MessagePlainObject: Plain {

    // MARK: - Properties

    var uniqueId: UniqueID {
        return UniqueID(value: id)
    }

    /// Unique identifier
    let id: Int

    /// Sending date
    let date: Date

    /// Message text
    let text: String

    /// Sender's id
    let senderId: Int

    /// Receiver's id
    let receiverId: Int

    /// Message type
    let type: Int

    /// True if the message is incoming
    let isIncoming: Bool

    /// True if the message has been read
    let isRead: Bool
}
