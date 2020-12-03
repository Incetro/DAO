//
//  DialogsTranslator.swift
//  SDAO
//
//  Created by incetro on 07/10/2019.
//

import SDAO
import Monreau

// MARK: - DialogsTranslator

final class DialogsTranslator {

    // MARK: - Aliases

    typealias PlainModel = DialogPlainObject
    typealias DatabaseModel = DialogModelObject

    private lazy var dialogStorage = RealmStorage<DialogModelObject>(
        configuration: RealmConfiguration(inMemoryIdentifier: "DAO")
    )
}

// MARK: - Translator

extension DialogsTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        DialogPlainObject(
            id: Int(model.uniqueId) ?? 0,
            isPinned: model.isPinned,
            messages: try MessagesTranslator().translate(
                models: Array(model.messages)
            )
        )
    }

    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try dialogStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? DialogModelObject()
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
