//
//  DAO.swift
//  DAO
//
//  Created by incetro on 14/07/2017.
//
//

import Monreau

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

    /// Create entity in the database
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
    /// - Parameter plains: plain objects with all data for creating
    /// - Throws: error if any entity cannot be created
    public func create(_ plains: [Plain]) throws {
        try plains.forEach(create)
    }
    
    // MARK: - Read
    
    /// Returns the number of objects which fits the predicate
    /// - Parameter predicate: some predicate
    func count(predicatedBy predicate: Predicate? = nil) throws -> Int {
        return try storage.count(predicatedBy: predicate)
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
    
    /// Read entity from database of `Plain` type
    ///
    /// - Parameter primaryKey: entity identifier
    /// - Returns: instance of existant entity or nil
    /// - Throws: error if entity cannot be read
    public func read(byPrimaryKey primaryKey: UniqueID) throws -> Plain? {
        guard let model = try storage.read(byPrimaryKey: primaryKey.rawValue) else {
            return nil
        }
        let plain = try translator.translate(model: model)
        return plain
    }
    
    /// Read entity from database of `Plain` filtered by predicate
    ///
    /// - Parameters:
    ///   - predicate: Filter
    /// - Returns: ordered array of entities
    /// - Throws: error if any entity cannot be read
    public func read(predicatedBy predicate: Predicate) throws -> [Plain] {
        let models = try storage.read(predicatedBy: predicate)
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
    public func read(predicatedBy predicate: Predicate, orderedBy name: String, ascending: Bool) throws -> [Plain] {
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
        let plainSet = Set(plains.map { $0.uniqueId })
        let modelSet = Set(try read().map { $0.uniqueId })
        try erase(byPrimaryKeys: Array(modelSet.intersection(plainSet)))
        try plains.forEach(persist)
    }
    
    // MARK: - Delete
    
    /// Delete all entities of `Plain` type
    ///
    /// - Throws: error if any entity can not be deleted
    public func erase() throws {
        try storage.erase()
    }
    
    /// Delete entity of `Plain` type by identifier
    ///
    /// - Parameter primaryKeys: identifier
    /// - Throws: error if entity cannot be deleted
    public func erase(byPrimaryKey primaryKey: UniqueID) throws {
        try storage.erase(byPrimaryKey: primaryKey.rawValue)
    }

    /// Delete entities of `Plain` type by plain objects
    ///
    /// - Parameter plains: plain objects
    /// - Throws: error if any entity cannot be deleted
    public func erase(_ plains: [Plain]) throws {
        try erase(byPrimaryKeys: plains.map { $0.uniqueId })
    }

    /// Delete entity of `Plain` type by identifiers
    ///
    /// - Parameter primaryKeys: identifiers
    /// - Throws: error if any entity cannot be deleted
    public func erase(byPrimaryKeys primaryKeys: [UniqueID]) throws {
        let predicate = NSPredicate(format: "uniqueId IN %@", primaryKeys.map { $0.rawValue })
        try erase(predicatedBy: predicate)
    }

    /// Delete entities of `Plain` type by predicate
    ///
    /// - Parameter predicate: filter
    /// - Throws: error if any entity cannot be deleted
    public func erase(predicatedBy predicate: Predicate) throws {
        try storage.erase(predicatedBy: predicate)
    }
}
