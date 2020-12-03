//
//  UsersTranslator.swift
//  SDAO
//
//  Created by incetro on 26/08/2018.
//

import SDAO
import Monreau

// MARK: - UsersTranslator

final class UsersTranslator {

    // MARK: - Aliases

    typealias PlainModel = UserPlainObject
    typealias DatabaseModel = UserModelObject

    private lazy var userStorage = RealmStorage<UserModelObject>(
        configuration: RealmConfiguration(inMemoryIdentifier: "DAO")
    )
}

// MARK: - Translator

extension UsersTranslator: Translator {

    func translate(model: DatabaseModel) throws -> PlainModel {
        UserPlainObject(
            id: Int(model.uniqueId) ?? 0,
            name: model.name,
            age: model.age,
            dialogs: try DialogsTranslator().translate(
                models: Array(model.dialogs)
            )
        )
    }

    func translate(plain: PlainModel) throws -> DatabaseModel {
        let model = try userStorage.read(byPrimaryKey: plain.uniqueId.rawValue) ?? UserModelObject()
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
