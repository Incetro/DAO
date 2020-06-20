//
//  UsersTranslator.swift
//  DAO
//
//  Created by incetro on 26/08/2018.
//

import DAO

// MARK: - UsersTranslator

final class UsersTranslator {
    
    typealias PlainModel = UserPlainObject
    typealias DatabaseModel = UserModelObject
}

// MARK: - Translator

extension UsersTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        return UserPlainObject(
            id: Int(model.uniqueId) ?? 0,
            name: model.name,
            age: model.age,
            dialogs: try DialogsTranslator().translate(
                models: Array(model.dialogs)
            )
        )
    }

    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = UserModelObject()
        try translate(from: plain, to: model)
        return model
    }
    
    func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws {
        if databaseModel.uniqueId.isEmpty {
            databaseModel.uniqueId = plain.uniqueId.rawValue
        }
        databaseModel.age = plain.age
        databaseModel.name = plain.name
        databaseModel.dialogs.removeAll()
        databaseModel.dialogs.append(
            objectsIn: try DialogsTranslator().translate(
                plains: Array(plain.dialogs)
            )
        )
    }
}
