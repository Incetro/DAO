//
//  RealmModel.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import RealmSwift

// MARK: - RealmModelWrapper

open class RealmModelWrapper: Object {
    
    /// Primary key
    @objc dynamic public var nioID = ""
}

// MARK: - RealmModel

open class RealmModel: RealmModelWrapper, Model {
    
    /// Primary key type = String for all models
    public typealias PrimaryType = String
    
    /// Primary key name
    public static var primaryKey: String {
        return "nioID"
    }
}
