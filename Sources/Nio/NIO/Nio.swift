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
    
    private static func coredata<M: ManagedModel, P: Plain>(named name: String, store: CoreStoreType, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
    
        let storage    = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    private static func coredata<M: ManagedModel, P: Plain, TranslatorType: Translator>(named name: String, store: CoreStoreType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        let storage    = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    private static func coredata<M: ManagedModel, P: Plain, RefresherType: Refresher>(named name: String, store: CoreStoreType, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        let storage    = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    private static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, store: CoreStoreType, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        let storage = CoreStorage(withConfig: CoreStorageConfig(containerName: name, storeType: store), model: M.self)
        let nio     = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    public static func coredata<M: ManagedModel, P: Plain>(withContext context: NSManagedObjectContext, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        
        let storage    = CoreStorage<M>(withContext: context)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    public static func coredata<M: ManagedModel, P: Plain, TranslatorType: Translator>(withContext context: NSManagedObjectContext, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        let storage    = CoreStorage<M>(withContext: context)
        let refresher  = NioCoreRefresher(model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    public static func coredata<M: ManagedModel, P: Plain, RefresherType: Refresher>(withContext context: NSManagedObjectContext, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        let storage    = CoreStorage<M>(withContext: context)
        let translator = NioTranslator(withTransformType: .coredata, model: M.self, plain: P.self)
        let nio        = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    public static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(withContext context: NSManagedObjectContext, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        let storage = CoreStorage<M>(withContext: context)
        let nio     = DAO(storage: storage, translator: translator, refresher: refresher)
        
        return nio
    }
    
    public static func coredata<M: ManagedModel, P: Plain>(named name: String, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .coredata, model: M.self, plain: P.self)
    }
    
    public static func coredataInMemory<M: ManagedModel, P: Plain>(named name: String, model: M.Type, plain: P.Type) -> DAO<CoreStorage<M>, NioTranslator<M, P>, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .memory, model: M.self, plain: P.self)
    }
    
    public static func coredata<M: ManagedModel, P: Plain, TranslatorType: Translator>(named name: String, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .coredata, translator: translator)
    }
    
    public static func coredataInMemory<M: ManagedModel, P: Plain, TranslatorType: Translator>(named name: String, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, NioCoreRefresher<M, P>> {
        
        return Nio.coredata(named: name, store: .memory, translator: translator)
    }
    
    public static func coredata<M: ManagedModel, P: Plain, RefresherType: Refresher>(named name: String, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        return Nio.coredata(named: name, store: .coredata, refresher: refresher)
    }
    
    public static func coredataInMemory<M: ManagedModel, P: Plain, RefresherType: Refresher>(named name: String, refresher: RefresherType) -> DAO<CoreStorage<M>, NioTranslator<M, P>, RefresherType> {
        
        return Nio.coredata(named: name, store: .memory, refresher: refresher)
    }
    
    public static func coredata<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        return Nio.coredata(named: name, store: .coredata, refresher: refresher, translator: translator)
    }
    
    public static func coredataInMemory<M: ManagedModel, TranslatorType: Translator, RefresherType: Refresher>(named name: String, refresher: RefresherType, translator: TranslatorType) -> DAO<CoreStorage<M>, TranslatorType, RefresherType> {
        
        return Nio.coredata(named: name, store: .memory, refresher: refresher, translator: translator)
    }
}
