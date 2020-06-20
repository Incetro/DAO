//
//  MessagePlainObject.swift
//  DAO
//
//  Created by incetro on 07/10/2019.
//

import DAO
import Foundation

// MARK: - MessagePlainObject

struct MessagePlainObject: Plain {

    var uniqueId: UniqueID {
        return UniqueID(value: id)
    }
    
    // MARK: - Properties
    
    let id: Int
    let date: Date
    let text: String
    let senderId: Int
    let receiverId: Int
    let type: Int
    let isIncoming: Bool
    let isRead: Bool
}
