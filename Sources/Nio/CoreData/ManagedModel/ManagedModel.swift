//
//  ManagedModel.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

import CoreData

// MARK: - ManagedModel

/// If you use CoreData you must inherit your models from this class

public class ManagedModel: NSManagedObject, Model {
    
    @NSManaged var nioID: String
    
    public typealias PrimaryType = String
    
    public static var primaryKey: String {
        
        return "nioID"
    }
}
