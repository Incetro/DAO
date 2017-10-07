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
    
    associatedtype TranslatingModel: Model
    associatedtype TranslatingPlain: Plain
    
    /// Convert database model to plain object
    ///
    /// - Parameter model: Database model
    /// - Returns: Plain object
    /// - Throws: Translation error
    func translate(model: TranslatingModel) throws -> TranslatingPlain
}

public extension Translator {
    
    /// Convert database models to plain objects
    ///
    /// - Parameter models: Database models
    /// - Returns: Plain objects
    /// - Throws: Translation error
    func translate(models: [TranslatingModel]) throws -> [TranslatingPlain] {
        return try models.map {
            try self.translate(model: $0)
        }
    }
}
