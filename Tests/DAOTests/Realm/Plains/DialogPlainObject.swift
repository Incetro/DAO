//
//  DialogPlainObject.swift
//  SDAO
//
//  Created by incetro on 07/10/2019.
//

import SDAO

// MARK: - DialogPlainObject

struct DialogPlainObject: Plain {

    // MARK: - Properties

    var uniqueId: UniqueID {
        return UniqueID(value: id)
    }

    /// Unique id
    let id: Int

    /// True if the dialog has been pinned
    let isPinned: Bool

    /// All available (stored) the dialog's messages
    let messages: [MessagePlainObject]
}
