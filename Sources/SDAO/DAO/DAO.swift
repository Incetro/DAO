//
//  DAO.swift
//  DAO
//
//  Created by incetro on 14/07/2017.
//
//

import Monreau
import Foundation

// MARK: - DAO

public class DAO<S: Storage, T: Translator> where S.Model == T.DatabaseModel, S.Key == String {
    
    // MARK: - Types
    
    /// Database model type
    public typealias Model = T.DatabaseModel

    /// Plain object type
    public typealias Plain = T.PlainModel
    
    /// Primary key type
    public typealias PKType = S.Key
    
    // MARK: - Properties
    
    /// Database storage
    private let storage: S
    
    /// Objects translator
    private let translator: T
    
    // MARK: - Initializers
    
    /// Standard initializer
    ///
    /// - Parameters:
    ///   - storage: database storage
    ///   - translator: translator for current `Model` and `Plain` types
    public init(storage: S, translator: T) {
        self.storage = storage
        self.translator = translator
    }
    
    // MARK: - Create

    /// Create entity in database
    ///
    /// - Parameter plain: plain object with all data for creating
    /// - Throws: error if entity cannot be created
    public func create(_ plain: Plain) throws {
        try storage.create { model in
            try translator.translate(from: plain, to: model)
        }
    }
    
    /// Create entities in database
    ///
    /// - Parameter plains: plain objects with all necessary data for creating
    /// - Throws: error if any entity cannot be created
    public func create(_ plains: [Plain]) throws {
        try plains.forEach(create)
    }
    
    // MARK: - Read
    
    /// Returns the number of objects which fits the predicate
    /// - Parameter predicate: some predicate
    public func count(predicatedBy predicate: MPredicate? = nil) throws -> Int {
        try storage.count(predicatedBy: predicate)
    }

    /// Returns the number of objects which fits the predicate
    /// - Parameter predicate: some predicate
    public func count(predicatedBy predicate: NSPredicate) throws -> Int {
        try storage.count(predicatedBy: predicate)
    }
    
    /// Read all entities from database of `Plain` type
    ///
    /// - Returns: array of entities
    /// - Throws: error if any entity cannot be read
    public func read() throws -> [Plain] {
        let models = try storage.read()
        let plains = try translator.translate(models: models)
        return plains
    }

    /// Read an entity from database of `Plain` type
    ///
    /// - Parameter primaryKey: entity identifier
    /// - Returns: instance of existing entity or nil
    /// - Throws: error if entity cannot be read
    public func read(byPrimaryKey primaryKey: UniqueID) throws -> Plain? {
        guard let model = try storage.read(byPrimaryKey: primaryKey.rawValue) else {
            return nil
        }
        let plain = try translator.translate(model: model)
        return plain
    }

    /// Read entities from database of `Plain` type
    ///
    /// - Parameter primaryKeys: entities identifiers
    /// - Returns: instances of existing entities
    /// - Throws: error if entities cannot be read
    public func read(byPrimaryKeys primaryKeys: [UniqueID]) throws -> [Plain] {
        let predicate = NSPredicate(format: "uniqueId IN %@", primaryKeys.map(\.rawValue))
        let models = try storage.read(predicatedBy: predicate)
        let plains = try translator.translate(models: models)
        return plains
    }

    /// Read an entity from database of `Plain` type
    ///
    /// - Parameter primaryKey: entity identifier
    /// - Returns: instance of existing entity or nil
    /// - Throws: error if entity cannot be read
    public func read(byPrimaryKey primaryKey: String) throws -> Plain? {
        try read(byPrimaryKey: UniqueID(rawValue: primaryKey))
    }

    /// Read entities from database of `Plain` type
    ///
    /// - Parameter primaryKeys: entities identifiers
    /// - Returns: instances of existing entities
    /// - Throws: error if entities cannot be read
    public func read(byPrimaryKeys primaryKeys: [String]) throws -> [Plain] {
        try read(byPrimaryKeys: primaryKeys.map(UniqueID.init))
    }

    /// Read an entity from database of `Plain` type
    ///
    /// - Parameter primaryKey: entity identifier
    /// - Returns: instance of existing entity or nil
    /// - Throws: error if entity cannot be read
    public func read(byPrimaryKey primaryKey: Numeric) throws -> Plain? {
        try read(byPrimaryKey: UniqueID(value: primaryKey))
    }

    /// Read entities from database of `Plain` type
    ///
    /// - Parameter primaryKeys: entities identifiers
    /// - Returns: instances of existing entities
    /// - Throws: error if entities cannot be read
    public func read(byPrimaryKeys primaryKeys: [Numeric]) throws -> [Plain] {
        try read(byPrimaryKeys: primaryKeys.map(UniqueID.init))
    }

    /// Read entities from database of `Plain` filtered by predicate
    ///
    /// - Parameters:
    ///   - predicate: some filter
    /// - Returns: ordered array of entities
    /// - Throws: error if any entity cannot be read
    public func read(predicatedBy predicate: MPredicate) throws -> [Plain] {
        let predicate = NSPredicate(format: predicate.filter)
        return try read(predicatedBy: predicate)
    }

    /// Read entities from database of `Plain` filtered by predicate
    ///
    /// - Parameters:
    ///   - predicate: some filter
    /// - Returns: ordered array of entities
    /// - Throws: error if any entity cannot be read
    public func read(predicatedBy predicate: NSPredicate) throws -> [Plain] {
        let models = try storage.read(predicatedBy: predicate)
        let plains = try translator.translate(models: models)
        return plains
    }

    // Read all entities in storage ordered by the given key
    ///
    /// - Parameters:
    ///   - key: key for sorting
    ///   - ascending: ascending flag
    /// - Returns: all found objects ordered by the given key
    public func read(orderedBy field: String, asceding: Bool = true) throws -> [Plain] {
        let models = try storage.read(orderedBy: field, ascending: asceding)
        let plains = try translator.translate(models: models)
        return plains
    }
    
    /// Read entity from database of `Plain` type ordered by field
    ///
    /// - Parameters:
    ///   - predicate: filter
    ///   - name: ordering field
    ///   - ascending: ascending flag (descending otherwise)
    /// - Returns: ordered array of entities
    /// - Throws: error if any entity cannot be read
    public func read(predicatedBy predicate: MPredicate, orderedBy name: String, ascending: Bool) throws -> [Plain] {
        let predicate = NSPredicate(format: predicate.filter)
        return try read(predicatedBy: predicate, orderedBy: name, ascending: ascending)
    }

    /// Read entity from database of `Plain` type ordered by field
    ///
    /// - Parameters:
    ///   - predicate: filter
    ///   - name: ordering field
    ///   - ascending: ascending flag (descending otherwise)
    /// - Returns: ordered array of entities
    /// - Throws: error if any entity cannot be read
    public func read(predicatedBy predicate: NSPredicate, orderedBy name: String, ascending: Bool) throws -> [Plain] {
        let sorter = SortDescriptor(key: name, ascending: ascending)
        let models = try storage.read(predicatedBy: predicate, includeSubentities: true, sortDescriptors: [sorter])
        let plains = try translator.translate(models: models)
        return plains
    }
    
    // MARK: - Update

    /// Save new entity or update existing
    ///
    /// - Parameter plain: plain object with all data for saving
    /// - Throws: error if entity can not be saved
    public func persist(_ plain: Plain) throws {
        let primaryKey = plain.uniqueId.rawValue
        if let _ = try storage.read(byPrimaryKey: primaryKey) {
            try storage.persist(withPrimaryKey: primaryKey) { model in
                guard let model = model else {
                    fatalError("There is some unknown error with Monreau framework (model must exists here)")
                }
                try translator.translate(from: plain, to: model)
            }
        } else {
            try create(plain)
        }
    }
    
    /// Saving new entities or update existing
    ///
    /// - Parameters:
    ///   - plains: plain objects with all data for saving
    /// - Throws: error if any entity can not be saved
    public func persist(_ plains: [Plain]) throws {
        try plains.forEach(persist)
    }
    
    // MARK: - Delete
    
    /// Delete all entities of `Plain` type
    ///
    /// - Throws: error if any entity can not be deleted
    public func erase() throws {
        try storage.erase()
    }
    
    /// Delete an entity of `Plain` type by given identifier
    ///
    /// - Parameter primaryKey: identifier
    /// - Throws: error if entity cannot be deleted
    public func erase(byPrimaryKey primaryKey: UniqueID) throws {
        try storage.erase(byPrimaryKey: primaryKey.rawValue)
    }

    /// Delete an entity of `Plain` type by given identifier
    ///
    /// - Parameter primaryKey: identifier
    /// - Throws: error if entity cannot be deleted
    public func erase<K: Numeric>(byPrimaryKey primaryKey: K) throws {
        try erase(byPrimaryKey: UniqueID(value: primaryKey))
    }

    /// Delete an entity of `Plain` type by given identifier
    ///
    /// - Parameter primaryKeys: identifiers
    /// - Throws: error if entity cannot be deleted
    public func erase<K: Numeric>(byPrimaryKeys primaryKeys: [K]) throws {
        try erase(byPrimaryKeys: primaryKeys.map(UniqueID.init))
    }

    /// Delete an entity of `Plain` type by given identifier
    ///
    /// - Parameter primaryKey: identifier
    /// - Throws: error if entity cannot be deleted
    public func erase(byPrimaryKey primaryKey: String) throws {
        try erase(byPrimaryKey: UniqueID(rawValue: primaryKey))
    }

    /// Delete an entity of `Plain` type by given identifier
    ///
    /// - Parameter primaryKeys: identifiers
    /// - Throws: error if entity cannot be deleted
    public func erase(byPrimaryKeys primaryKeys: [String]) throws {
        try erase(byPrimaryKeys: primaryKeys.map(UniqueID.init))
    }

    /// Delete the given entity
    ///
    /// - Parameter plain: some plain object for deletion
    /// - Throws: error if an entity cannot be deleted
    public func erase(_ plain: Plain) throws {
        try erase(byPrimaryKey: plain.uniqueId)
    }
    
    /// Delete the given entities
    ///
    /// - Parameter plains: some plain objects for deletion
    /// - Throws: error if any entity cannot be deleted
    public func erase(_ plains: [Plain]) throws {
        try erase(byPrimaryKeys: plains.map(\.uniqueId))
    }

    /// Delete entity of `Plain` type by given identifiers
    ///
    /// - Parameter primaryKeys: the given identifiers
    /// - Throws: error if any entity cannot be deleted
    public func erase(byPrimaryKeys primaryKeys: [UniqueID]) throws {
        let predicate = NSPredicate(format: "uniqueId IN %@", primaryKeys.map(\.rawValue))
        try erase(predicatedBy: predicate)
    }

    /// Delete entities of `Plain` type by given predicate
    ///
    /// - Parameter predicate: the given filter
    /// - Throws: error if any entity cannot be deleted
    public func erase(predicatedBy predicate: MPredicate) throws {
        try storage.erase(predicatedBy: predicate)
    }

    /// Delete entities of `Plain` type by given predicate
    ///
    /// - Parameter predicate: the given filter
    /// - Throws: error if any entity cannot be deleted
    public func erase(predicatedBy predicate: NSPredicate) throws {
        try storage.erase(predicatedBy: predicate)
    }
}
