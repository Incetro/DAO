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
    ///   - store: Store type
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    
    private static func coredata<M: ManagedModel, P: Plain>(named name: String, store: CoreStoreType, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
    
        let storage    = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - translator: Custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    
    private static func coredata<M: ManagedModel, P: Plain, TranslatorType: Translator>(named name: String, store: CoreStoreType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        let storage    = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - refresher: Custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    
    private static func coredata<M: ManagedModel, P: Plain, RefresherType: Refresher>(named name: String, store: CoreStoreType, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        let storage    = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - refresher: Custom Refresher
    ///   - translator: Custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    
    private static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, store: CoreStoreType, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        let storage = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let nio     = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with built-in Translator and Refresher for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    
    public static func coredata<M: ManagedModel, P: Plain>(withContext context: NSManagedObjectContext, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        
        let storage    = CoreStorage<M>(withContext: context)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - translator: Custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    
    public static func coredata<M: ManagedModel, P: Plain, TranslatorType: Translator>(withContext context: NSManagedObjectContext, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        let storage    = CoreStorage<M>(withContext: context)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - refresher: Custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    
    public static func coredata<M: ManagedModel, P: Plain, RefresherType: Refresher>(withContext context: NSManagedObjectContext, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        let storage    = CoreStorage<M>(withContext: context)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData
    ///
    /// - Parameters:
    ///   - context: NSManagedObjectContext instance
    ///   - refresher: Custom Refresher
    ///   - translator: Custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    
    public static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(withContext context: NSManagedObjectContext, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        let storage = CoreStorage<M>(withContext: context)
        let nio     = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    /// Returns DAO with built-in Translator and Refresher for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    
    public static func coredata<M: ManagedModel, P: Plain>(named name: String, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .coredata, model: M.self, plain: P.self)
    }
    
    /// Returns DAO with built-in Translator and Refresher for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - model: CoreData model class
    ///   - plain: Plain object class
    /// - Returns: DAO with built-in Translator and Refresher for CoreData
    
    public static func coredataInMemory<M: ManagedModel, P: Plain>(named name: String, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .memory, model: M.self, plain: P.self)
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - translator: Custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    
    public static func coredata<M: ManagedModel, P: Plain, TranslatorType: Translator>(named name: String, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .coredata, translator: translator)
    }
    
    /// Returns DAO with built-in Refresher and custom Translator for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - translator: Custom Translator
    /// - Returns: DAO with built-in Refresher and custom Translator for CoreData
    
    public static func coredataInMemory<M: ManagedModel, P: Plain, TranslatorType: Translator>(named name: String, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .memory, translator: translator)
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - refresher: Custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    
    public static func coredata<M: ManagedModel, P: Plain, RefresherType: Refresher>(named name: String, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        return Nio.coredata(named: name, store: .coredata, refresher: refresher)
    }
    
    /// Returns DAO with built-in Translator and custom Refresher for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - refresher: Custom Refresher
    /// - Returns: DAO with built-in Translator and custom Refresher for CoreData
    
    public static func coredataInMemory<M: ManagedModel, P: Plain, RefresherType: Refresher>(named name: String, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        return Nio.coredata(named: name, store: .memory, refresher: refresher)
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData with NSSQLiteStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - refresher: Custom Refresher
    ///   - translator: Custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    
    public static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        return Nio.coredata(named: name, store: .coredata, refresher: refresher, translator: translator)
    }
    
    /// Returns DAO with custom Translator and Refresher for CoreData with NSInMemoryStoreType
    ///
    /// - Parameters:
    ///   - name: .xcdatamodeld file name (without extension)
    ///   - store: Store type
    ///   - refresher: Custom Refresher
    ///   - translator: Custom Translator
    /// - Returns: DAO with custom Translator and Refresher for CoreData
    
    public static func coredataInMemory<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        return Nio.coredata(named: name, store: .memory, refresher: refresher, translator: translator)
    }
}
