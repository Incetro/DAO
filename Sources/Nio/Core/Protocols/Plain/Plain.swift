//
//  Plain.swift
//  Nio
//
//  Created by incetro on 17/07/2017.
//
//

import Foundation

// MARK: - Plain

/// Parent for all plain objects

public protocol Plain {
    
    var nioID: NioID { get }
}

public extension Plain {
    
    /// Comparison function
    ///
    /// - Parameter other: entity compare with.
    /// - Returns: result of comparison.
    
    public func equals<T>(_ other: T) -> Bool where T: Plain {
        
        return self.nioID == other.nioID
    }
}
