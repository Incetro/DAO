//
//  DialogsTranslator.swift
//  DAO
//
//  Created by incetro on 07/10/2019.
//

import DAO

// MARK: - DialogsTranslator

final class DialogsTranslator {
    
    typealias PlainModel = DialogPlainObject
    typealias DatabaseModel = DialogModelObject
}

// MARK: - Translator

extension DialogsTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        return DialogPlainObject(
            id: Int(model.uniqueId) ?? 0,
            isPinned: model.isPinned,
            messages: try MessagesTranslator().translate(
                models: Array(model.messages)
            )
        )
    }

    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = DialogModelObject()
        try translate(from: plain, to: model)
        return model
    }
    
    func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.isPinned = plain.isPinned
        databaseModel.messages.removeAll()
        databaseModel.messages.append(
            objectsIn: try MessagesTranslator().translate(
                plains: plain.messages
            )
        )
    }
}

