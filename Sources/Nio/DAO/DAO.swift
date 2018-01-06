//
//  DAO.swift
//  DAO
//
//  Created by incetro on 14/07/2017.
//
//

import Monreau

// MARK: - DAO

public class DAO<StorageType: Storage, TranslatorType: Translator, RefresherType: Refresher> where StorageType.Model             == TranslatorType.TranslatingModel,
                                                                                                   RefresherType.RefreshingModel == TranslatorType.TranslatingModel,
                                                                                                   RefresherType.RefreshingPlain == TranslatorType.TranslatingPlain,
                                                                                                   StorageType.Key               == String {
    
    // MARK: - Types
    
    /// Database model type
    public typealias Model = TranslatorType.TranslatingModel
    
    /// Plain object type
    public typealias Plain = TranslatorType.TranslatingPlain
    
    /// Primary key type
    public typealias PKType = StorageType.Key
    
    // MARK: - Properties
    
    /// Database storage
    private let storage: StorageType
    
    /// Translator for current `Model` and `Plain` types
    private let refresher: RefresherType
    
    /// Refresher for current `Model` and `Plain` types
    private let translator: TranslatorType
    
    // MARK: - Initializers
    
    /// Standard initializer
    ///
    /// - Parameters:
    ///   - storage: database storage
    ///   - translator: translator for current `Model` and `Plain` types
    ///   - refresher: Refresher for current `Model` and `Plain` types
    public init(storage: StorageType, translator: TranslatorType, refresher: RefresherType) {
        self.storage    = storage
        self.refresher  = refresher
        self.translator = translator
    }
    
    // MARK: - Create

    /// Create entity in the database
    ///
    /// - Parameter plain: plain object with all data for creating
    /// - Throws: error if entity cannot be created
    public func create(_ plain: Plain) throws {
        _ = try self.storage.create { model in
            try self.refresher.refresh(model, withPlain: plain)
        }
    }
    
    
    /// Create entities in database
    ///
    /// - Parameter plains: plain objects with all data for creating
    /// - Throws: error if any entity cannot be created
    public func create(_ plains: [Plain]) throws {
        try plains.forEach {
            try self.create($0)
        }
    }
    
    // MARK: - Read
    
    /// Read all entities from database of `Plain` type
    ///
    /// - Returns: array of entities
    /// - Throws: error if any entity cannot be read
    public func read() throws -> [Plain] {
        let models = try self.storage.findAll()
        let plains = try self.translator.translate(models: models)
        return plains
    }
    
    /// Read entity from database of `Plain` type
    ///
    /// - Parameter primaryKey: entity identifier
    /// - Returns: instance of existant entity or nil
    /// - Throws: error if entity cannot be read
    public func read(byPrimaryKey primaryKey: NioID) throws -> Plain? {
        guard let model = try self.storage.find(byPrimaryKey: primaryKey.rawValue) else {
            return nil
        }
        let plain = try self.translator.translate(model: model)
        return plain
    }
    
    /// Read entity from database of `Plain` filtered by predicate
    ///
    /// - Parameters:
    ///   - predicate: Filter
    /// - Returns: ordered array of entities
    /// - Throws: error if any entity cannot be read
    public func read(byPredicate predicate: Predicate) throws -> [Plain] {
        let models = try self.storage.find(byPredicate: predicate)
        let plains = try self.translator.translate(models: models)
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
    public func read(byPredicate predicate: Predicate, orderedBy name: String, ascending: Bool) throws -> [Plain] {
        let sorter = SortDescriptor(key: name, ascending: ascending)
        let models = try self.storage.find(byPredicate: predicate, includeSubentities: true, sortDescriptors: [sorter])
        let plains = try self.translator.translate(models: models)
        return plains
    }
    
    // MARK: - Update
    
    /// Save new entity or update existing
    ///
    /// - Parameter plain: plain object with all data for saving
    /// - Throws: error if entity can not be saved
    public func persist(_ plain: Plain) throws {
        if let model = try self.storage.find(byPrimaryKey: plain.nioID.rawValue) {
            try self.refresher.refresh(model, withPlain: plain)
            try self.storage.save()
        } else {
            try self.create(plain)
        }
    }
    
    /// Saving new entities or update existing
    ///
    /// - Parameters:
    ///   - plains: plain objects with all data for saving
    ///   - erase: true if need to clear database before persist
    /// - Throws: error if any entity can not be saved/deleted
    public func persist(_ plains: [Plain], erase: Bool) throws {
        if erase {
            try self.erase()
        } else {
            let plainSet = Set(plains.map { $0.nioID })
            let modelSet = Set(try self.read().map { $0.nioID })
            try self.erase(byPrimaryKeys: Array(modelSet.intersection(plainSet)))
        }
        try plains.forEach {
            try self.persist($0)
        }
    }
    
    /// Saving new entities or update existing
    ///
    /// - Parameters:
    ///   - plains: plain objects with all data for saving
    ///   - erase: true if need to clear database before persist
    ///   - success: success block
    ///   - failure: failure block
    /// - Throws: error if any entity can not be saved/deleted
    public func persistAsync(_ plains: [Plain], erase: Bool, success: @escaping () -> (), failure: @escaping (Error) -> ()) throws {
        DispatchQueue(label: "com.incetro.Nio.DAO.PersistAsync").async {
            do {
                try self.persist(plains, erase: erase)
                success()
            } catch {
                failure(error)
            }
        }
    }
    
    // MARK: - Delete
    
    /// Delete all entities of `Plain` type
    ///
    /// - Throws: error if any entity can not be deleted
    public func erase() throws {
        try self.storage.removeAll()
    }
    
    /// Delete entity of `Plain` type by identifier
    ///
    /// - Parameter primaryKeys: identifier
    /// - Throws: error if entity cannot be deleted
    public func erase(byPrimaryKey primaryKey: NioID) throws {
        try self.storage.remove(byPrimaryKey: primaryKey.rawValue)
    }
    
    /// Delete entity of `Plain` type by identifiers
    ///
    /// - Parameter primaryKeys: identifiers
    /// - Throws: error if any entity cannot be deleted
    public func erase(byPrimaryKeys primaryKeys: [NioID]) throws {
        try primaryKeys.forEach {
            try self.erase(byPrimaryKey: $0)
        }
    }
    
    /// Delete entities of `Plain` type by plain objects
    ///
    /// - Parameter plains: plain objects
    /// - Throws: error if any entity cannot be deleted
    public func erase(plains: [Plain]) throws {
        try self.erase(byPrimaryKeys: plains.map {
            $0.nioID
        })
    }
    
    /// Delete entities of `Plain` type by predicate
    ///
    /// - Parameter predicate: filter
    /// - Throws: error if any entity cannot be deleted
    public func erase(byPredicate predicate: Predicate) throws {
        try self.storage.remove(byPredicate: predicate)
    }
}
