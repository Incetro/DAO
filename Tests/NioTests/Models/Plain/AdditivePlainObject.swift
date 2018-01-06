//
//  AdditivePlainObject.swift
//  Nio
//
//  Created by incetro on 16/07/2017.
//
//

import Transformer

// MARK: - AdditivePlainObject

class AdditivePlainObject: TransformablePlain {
    
    var nioID: NioID {
        return NioID(value: id)
    }
    
    let id: Int64
    let name: String
    let price: Double
    
    init(with name: String, price: Double, id: Int64) {
        self.name = name
        self.id = id
        self.price = price
    }
    
    var position: PositionPlainObject? = nil
    
    required init(with resolver: Resolver) throws {
        self.id = try resolver.value("id")
        self.name = try resolver.value("name")
        self.price = try resolver.value("price")
        self.position = try? resolver.value("position")
    }
}
