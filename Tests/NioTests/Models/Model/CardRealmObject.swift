//
//  CardRealmObject.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio
import RealmSwift

// MARK: - CardRealmObject

class CardRealmObject: RealmModel {
    
    @objc dynamic var id = 0
    @objc dynamic var front = ""
    @objc dynamic var back = ""
    
    let deckLinkingObject = LinkingObjects(fromType: DeckRealmObject.self, property: "cards")
    
    var deck: DeckRealmObject {
        guard let deck = deckLinkingObject.first else {
            fatalError()
        }
        return deck
    }
}
