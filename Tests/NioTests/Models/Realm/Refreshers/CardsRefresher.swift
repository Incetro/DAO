//
//  CardsRefresher.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio
import Monreau

// MARK: - CardsRefresher

class CardsRefresher: Refresher {
    
    private let storage = RealmStorage<CardRealmObject>()
    
    func refresh(_ model: CardRealmObject, withPlain plain: CardPlainObject) throws {
        if model.nioID == "" {
            model.nioID = plain.nioID.rawValue
        }
        try storage.update(byPrimaryKey: model.nioID, configuration: { card in
            card?.front = plain.front
            card?.back = plain.back
            card?.id = plain.id
        })
    }
}
