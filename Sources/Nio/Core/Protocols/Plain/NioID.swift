//
//  NioID.swift
//  Nio
//
//  Created by incetro on 17/07/2017.
//
//

import Foundation

// MARK: - NioID

/// Primary key for all Plain objects

public struct NioID: RawRepresentable, Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        
        self.rawValue = rawValue
    }
    
    public init<T>(value: T) where T: Numeric {
        
        self.rawValue = String(describing: value)
    }
}

public extension RawRepresentable where RawValue : Hashable {
    
    public var hashValue: Int {
        
        return rawValue.hashValue
    }
}
