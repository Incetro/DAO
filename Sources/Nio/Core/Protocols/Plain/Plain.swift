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

    /// Unique identifier
    var uniqueId: UniqueID { get }
}

public extension Plain {
    
    /// Comparison function
    ///
    /// - Parameter other: entity compare with.
    /// - Returns: result of comparison.
    func equals<T>(_ other: T) -> Bool where T: Plain {
        return self.uniqueId == other.uniqueId
    }
}
