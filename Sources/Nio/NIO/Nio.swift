//
//  Nio.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

import Monreau
import CoreData

// MARK: - Nio

public class Nio {

    /// Returns DAO with built-in Translator and Refresher for CoreData
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    private static func coredata<M: ManagedModel, P>(named name: String, storage: CoreStorageType, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        let storage = CoreStorage<M>(withConfig: CoreStorageConfig(containerName: name, storeType: storage))
        let refresher = NioCoreRefresher(model: M.self, plain: P.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - translator: custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    private static func coredata<M: ManagedModel, P, TranslatorType: Translator>(named name: String, storage: CoreStorageType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        let storage = CoreStorage<M>(withConfig: CoreStorageConfig(containerName: name, storeType: storage))
        let refresher = NioCoreRefresher(model: M.self, plain: P.self)
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - refresher: custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    private static func coredata<M: ManagedModel, P, RefresherType: Refresher>(named name: String, storage: CoreStorageType, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        let storage = CoreStorage<M>(withConfig: CoreStorageConfig(containerName: name, storeType: storage))
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - refresher: custom Refresher
    ///   - translator: custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    private static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, storage: CoreStorageType, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        let storage = CoreStorage<M>(withConfig: CoreStorageConfig(containerName: name, storeType: storage))
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with custom Translator and Refresher for Realm
    ///
    /// - Parameters:
    ///   - model: Realm model class
    ///   - plain: Plain object class
    ///   - translator: custom Translator
    ///   - refresher: custom Refresher
    /// - Returns: AO with built-in Translator and Refresher for Realm
    public static func realm<M: RealmModel, P, TranslatorType: Translator, RefresherType: Refresher>(model: M.Type, plain: P.Type, translator: TranslatorType, refresher: RefresherType) -> DAO<RealmStorage<M>, TranslatorType, RefresherType> {
        return DAO(storage: RealmStorage(), translator: translator, refresher: refresher)
    }
    
    /// Returns DAO with custom Translator and Refresher for Realm
    ///
    /// - Parameters:
    ///   - model: Realm model class
    ///   - plain: Plain object class
    ///   - configuration: Realm database configuration
    ///   - translator: custom Translator
    ///   - refresher: custom Refresher
    /// - Returns: AO with built-in Translator and Refresher for Realm
    public static func realm<M: RealmModel, P, TranslatorType: Translator, RefresherType: Refresher>(model: M.Type, plain: P.Type, configuration: RealmConfiguration, translator: TranslatorType, refresher: RefresherType) -> DAO<RealmStorage<M>, TranslatorType, RefresherType> {
        return DAO(storage: RealmStorage<M>(configuration: configuration), translator: translator, refresher: refresher)
    }
    
    /// Returns DAO with built-in Translator and Refresher for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    public static func coredata<M: ManagedModel, P>(withContext context: NSManagedObjectContext, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        let storage = CoreStorage<M>(context: context)
        let refresher = NioCoreRefresher(model: M.self, plain: P.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - translator: custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    public static func coredata<M: ManagedModel, P, TranslatorType: Translator>(withContext context: NSManagedObjectContext, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        let storage = CoreStorage<M>(context: context)
        let refresher = NioCoreRefresher(model: M.self, plain: P.self)
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - refresher: custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    public static func coredata<M: ManagedModel, P, RefresherType: Refresher>(withContext context: NSManagedObjectContext, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        let storage = CoreStorage<M>(context: context)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - refresher: custom Refresher
    ///   - translator: custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    public static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(withContext context: NSManagedObjectContext, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        let storage = CoreStorage<M>(context: context)
        let nio = DAO(storage: storage, translator: translator, refresher: refresher)
        return nio
    }
    
    /// Returns DAO with built-in Translator and Refresher for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    public static func coredata<M: ManagedModel, P>(named name: String, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        return Nio.coredata(named: name, storage: .coredata, model: M.self, plain: P.self)
    }
    
    /// Returns DAO with built-in Translator and Refresher for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    public static func coredataInMemory<M: ManagedModel, P>(named name: String, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        return Nio.coredata(named: name, storage: .memory, model: M.self, plain: P.self)
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - translator: custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    public static func coredata<M: ManagedModel, P, TranslatorType: Translator>(named name: String, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        return Nio.coredata(named: name, storage: .coredata, translator: translator)
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - translator: custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    public static func coredataInMemory<M: ManagedModel, P, TranslatorType: Translator>(named name: String, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        return Nio.coredata(named: name, storage: .memory, translator: translator)
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - refresher: custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    public static func coredata<M: ManagedModel, P, RefresherType: Refresher>(named name: String, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        return Nio.coredata(named: name, storage: .coredata, refresher: refresher)
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - refresher: custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    public static func coredataInMemory<M: ManagedModel, P, RefresherType: Refresher>(named name: String, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        return Nio.coredata(named: name, storage: .memory, refresher: refresher)
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - refresher: custom Refresher
    ///   - translator: custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    public static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        return Nio.coredata(named: name, storage: .coredata, refresher: refresher, translator: translator)
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - storage: storage type
    ///   - refresher: custom Refresher
    ///   - translator: custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    public static func coredataInMemory<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        return Nio.coredata(named: name, storage: .memory, refresher: refresher, translator: translator)
    }
}
