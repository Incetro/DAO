//
//  DeckRefresher.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio
import Monreau

// MARK: - DeckRefresher

class DeckRefresher: Refresher {
    
    private let cardsRefresher = CardsRefresher()
    private let deckStorage = RealmStorage<DeckRealmObject>()
    private let cardStorage = RealmStorage<CardRealmObject>()
    
    func refresh(_ model: DeckRealmObject, withPlain plain: DeckPlainObject) throws {
        
        if model.cards.isEmpty {
            for card in plain.cards {
                model.cards.append(try cardStorage.create { [weak self] object in
                    try self?.cardsRefresher.refresh(object, withPlain: card)
                })
            }
        } else {
            for card in plain.cards {
                try cardStorage.update(byPrimaryKey: plain.nioID.rawValue, configuration: { [weak self] object in
                    if let object = object {
                        try self?.cardsRefresher.refresh(object, withPlain: card)
                    }
                })
            }
        }
        
        try deckStorage.update(byPrimaryKey: model.nioID) { deck in
            deck?.name = plain.name
        }
    }
}
