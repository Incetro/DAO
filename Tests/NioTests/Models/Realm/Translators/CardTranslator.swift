//
//  CardTranslator.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio

// MARK: - CardTranslator

class CardTranslator: Translator {
    
    func translate(model: CardRealmObject) throws -> CardPlainObject {
        return CardPlainObject(id: model.id, front: model.front, back: model.back)
    }
}
