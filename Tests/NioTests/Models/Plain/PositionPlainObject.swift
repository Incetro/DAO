//
//  PositionPlainObject.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

import Transformer

// MARK: - PositionPlainObject

class PositionPlainObject: TransformablePlain {
    
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
    
    var category: CategoryPlainObject? = nil
    var additives: [AdditivePlainObject] = []
    
    required init(with resolver: Resolver) throws {
        self.id = try  resolver.value("id")
        self.name = try  resolver.value("name")
        self.price = try  resolver.value("price")
        self.category = try? resolver.value("category")
        self.additives = (try? resolver.value("additives")) ?? []
    }
}
