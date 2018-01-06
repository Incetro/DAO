//
//  DeckPlainObject.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio
import Transformer

// MARK: - DeckPlainObject

class DeckPlainObject: Plain {
    
    var nioID: NioID {
        return NioID(rawValue: name)
    }
    
    let name: String
    var cards: [CardPlainObject] = []
    
    init(name: String, cards: [CardPlainObject] = []) {
        self.name = name
        self.cards = cards
    }
}
