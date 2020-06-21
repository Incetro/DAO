//
//  UserPlainObject.swift
//  DAO
//
//  Created by incetro on 26/08/2018.
//

import DAO

// MARK: - UserPlainObject

struct UserPlainObject: Plain {
    
    // MARK: - Properties

    var uniqueId: UniqueID {
        return UniqueID(value: id)
    }

    /// Unique identifier
    let id: Int

    /// User's name
    let name: String

    /// User's age
    let age: Int

    /// User's dialogs
    let dialogs: [DialogPlainObject]
}
