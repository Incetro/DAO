//
//  ManagedModel.swift
//  DAO
//
//  Created by incetro on 15/07/2017.
//
//

import CoreData

// MARK: - ManagedModel

/// If you use CoreData you must inherit your models from this class
open class ManagedModel: NSManagedObject, Model {
    
    /// Primary key
    @NSManaged var uniqueId: String
    
    /// Primary key type = String for all models
    public typealias PrimaryType = String
    
    /// Primary key name
    public static var primaryKey: String {
        return "uniqueId"
    }
}
