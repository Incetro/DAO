//
//  UniqueID.swift
//  DAO
//
//  Created by incetro on 17/07/2017.
//
//

import Foundation

// MARK: - UniqueID

/// Primary key for all Plain objects

public struct UniqueID: RawRepresentable, Hashable {
    
    // MARK: - RawRepresentable
    
    /// String value
    public let rawValue: String
    
    // MARK: - Initializers
    
    /// Default initializer
    ///
    /// - Parameter rawValue: string value
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// Generic initializer (when id is not string)
    ///
    /// - Parameter value: some numeric value
    public init<T>(value: T) where T: Numeric {
        self.rawValue = String(describing: value)
    }
}

// MARK: - RawRepresentable

public extension RawRepresentable where RawValue: Hashable {
    var hashValue: Int {
        return rawValue.hashValue
    }
}
