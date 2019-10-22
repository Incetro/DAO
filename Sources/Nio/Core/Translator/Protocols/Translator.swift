//
//  Translator.swift
//  Nio
//
//  Created by incetro on 14/07/2017.
//
//

import Monreau

// MARK: - Translator

/// Base protocol for Trnalsators that translate database models to plain objects
public protocol Translator {

    associatedtype DatabaseModel: Model
    associatedtype PlainModel: Plain

    /// Convert database model to plain object
    ///
    /// - Parameter model: database model
    /// - Returns: plain object
    /// - Throws: translation error
    func translate(model: DatabaseModel) throws -> PlainModel

    /// Convert database models to plain objects
    ///
    /// - Parameter models: database models
    /// - Returns: plain objects
    /// - Throws: translation error
    func translate(models: [DatabaseModel]) throws -> [PlainModel]

    /// Convert plain object to database model
    ///
    /// - Parameter model: plain object
    /// - Returns: database model
    /// - Throws: translation error
    func translate(plain: PlainModel) throws -> DatabaseModel

    /// Convert plain objects to database models
    ///
    /// - Parameter plains: plain objects
    /// - Returns: database models
    /// - Throws: translation error
    func translate(plains: [PlainModel]) throws -> [DatabaseModel]

    /// Translates data from the given plain object to the given database model
    /// - Parameter plain: some plain object
    /// - Parameter databaseModel: some database model
    func translate(from plain: PlainModel, to databaseModel: DatabaseModel) throws

    /// Translates data from the given plain object to the given database model
    /// - Parameter plain: some plain object
    /// - Parameter databaseModel: some database model
    func translate(from plains: [PlainModel], to databaseModels: [DatabaseModel]) throws
}

public extension Translator {
    
    /// Convert database models to plain objects
    ///
    /// - Parameter models: database models
    /// - Returns: plain objects
    /// - Throws: translation error
    func translate(models: [DatabaseModel]) throws -> [PlainModel] {
        return try models.map(translate)
    }

    /// Convert plain objects to database models
    ///
    /// - Parameter plains: plain objects
    /// - Returns: database models
    /// - Throws: translation error
    func translate(plains: [PlainModel]) throws -> [DatabaseModel] {
        return try plains.map(translate)
    }

    /// Translates data from the given plain object to the given database model
    /// - Parameter plain: some plain object
    /// - Parameter databaseModel: some database model
    func translate(from plains: [PlainModel], to databaseModels: [DatabaseModel]) throws {
        guard plains.count == databaseModels.count else {
            let error = NSError(
                domain: "com.dao.translator",
                code: 1000,
                userInfo: [
                    NSLocalizedDescriptionKey : "Plain objects count must be equal to database objects count"
                ]
            )
            throw error
        }
        for (plain, model) in zip(plains, databaseModels) {
            try translate(from: plain, to: model)
        }
    }
}
