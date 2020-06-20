//
//  DialogPlainObject.swift
//  DAO
//
//  Created by incetro on 07/10/2019.
//

import DAO

// MARK: - DialogPlainObject

struct DialogPlainObject: Plain {

    var uniqueId: UniqueID {
        return UniqueID(value: id)
    }
    
    // MARK: - Properties

    let id: Int
    let isPinned: Bool
    let messages: [MessagePlainObject]
}
