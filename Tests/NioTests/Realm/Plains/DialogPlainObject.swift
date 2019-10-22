//
//  DialogPlainObject.swift
//  Nio
//
//  Created by incetro on 07/10/2019.
//

import Nio

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
