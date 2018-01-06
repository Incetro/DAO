//
//  DeckRealmObject.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio
import RealmSwift

// MARK: - DeckRealmObject

class DeckRealmObject: RealmModel {
    @objc dynamic var name: String = ""
    let cards = List<CardRealmObject>()
}
