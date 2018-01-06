//
//  CardPlainObject.swift
//  Nio
//
//  Created by incetro on 06/01/2018.
//

import Nio
import Transformer

// MARK: - CardPlainObject

class CardPlainObject: Plain {
    
    var nioID: NioID {
        return NioID(value: id)
    }
    
    let id: Int
    let front: String
    let back: String
    
    init(id: Int, front: String, back: String) {
        self.id = id
        self.front = front
        self.back = back
    }
}
