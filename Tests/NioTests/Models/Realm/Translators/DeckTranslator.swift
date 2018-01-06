//
//  DeckTranslator.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio

// MARK: - DeckTranslator

class DeckTranslator: Translator {
    
    func translate(model: DeckRealmObject) throws -> DeckPlainObject {
        let cards = try CardTranslator().translate(models: model.cards.map { $0 })
        return DeckPlainObject(name: model.name, cards: cards)
    }
}
