//
//  Factories.swift
//  SDAO
//
//  Created by incetro on 07/10/2019.
//

import Foundation

// MARK: - UsersFactory

final class UsersFactory {
    
    func users(count: Int = 100) -> [UserPlainObject] {
        let users = (0..<count).map { index in
            return UserPlainObject(
                id: index + 1,
                name: "Username #\(index + 1)",
                age: Int(arc4random() % UInt32(10)) + 20,
                dialogs: DialogsFactory().dialogs()
            )
        }
        return users
    }
}

// MARK: - DialogsFactory

final class DialogsFactory {
    
    func dialogs(count: Int = 5) -> [DialogPlainObject] {
        let dialogs = (0..<count).map { index in
            return DialogPlainObject(
                id: index + 1,
                isPinned: Int(arc4random() % 2) == 0 ? true : false,
                messages: MessagesFactory().messages()
            )
        }
        return dialogs
    }
}

// MARK: - MessagesFactory

final class MessagesFactory {

    func messages(count: Int = 100) -> [MessagePlainObject] {
        var messages: [MessagePlainObject] = []
        for index in 0..<count {
            let message = MessagePlainObject(
                id: index + 1,
                date: Date().addingTimeInterval(TimeInterval(index * 5)),
                text: "Some message text here with the given index: \(index)",
                senderId: Int(arc4random() % UInt32(count)),
                receiverId: Int(arc4random() % UInt32(count)),
                type: Int(arc4random() % 50),
                isIncoming: Int(arc4random() % 2) == 0 ? true : false,
                isRead: index == count - 1 ? false : true
            )
            messages.append(message)
        }
        return messages
    }
}
