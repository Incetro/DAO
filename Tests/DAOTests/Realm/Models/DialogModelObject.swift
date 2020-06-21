//
//  DialogModelObject.swift
//  DAO
//
//  Created by incetro on 07/10/2019.
//

import DAO
import RealmSwift

// MARK: - DialogModelObject

final class DialogModelObject: RealmModel {

    // MARK: - Properties

    /// True if the dialog has been pinned
    @objc dynamic var isPinned = false

    /// All available (stored) the dialog's messages
    let messages = List<MessageModelObject>()
}
