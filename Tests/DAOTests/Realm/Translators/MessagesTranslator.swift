//
//  MessagesTranslator.swift
//  SDAO
//
//  Created by incetro on 07/10/2019.
//

import SDAO
import Monreau

// MARK: - MessagesTranslator

final class MessagesTranslator {

    // MARK: - Aliases

    typealias PlainModel = MessagePlainObject
    typealias DatabaseModel = MessageModelObject

    private lazy var messageStorage = RealmStorage<MessageModelObject>(
        configuration: RealmConfiguration(inMemoryIdentifier: "DAO")
    )
}

// MARK: - Translator

extension MessagesTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        MessagePlainObject(
            id: Int(model.uniqueId) ?? 0,
            date: model.date,
            text: model.text,
            senderId: model.senderId,
            receiverId: model.receiverId,
            type: model.type,
            isIncoming: model.isIncoming,
            isRead: model.isRead
        )
    }
    
    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try messageStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? MessageModelObject()
        try translate(from: plain, to: model)
        return model
    }

    func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.date = plain.date
        databaseModel.isIncoming = plain.isIncoming
        databaseModel.isRead = plain.isRead
        databaseModel.senderId = plain.senderId
        databaseModel.text = plain.text
        databaseModel.type = plain.type
        databaseModel.receiverId = plain.receiverId
    }
}
