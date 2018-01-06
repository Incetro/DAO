//
//  CategoryPlainObject.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

import Transformer

// MARK: - CategoryPlainObject

class CategoryPlainObject: TransformablePlain {
    
    var nioID: NioID {
        return NioID(value: id)
    }
    
    let id: Int64
    let name: String
    
    var positions: [PositionPlainObject] = []
    
    init(with name: String, id: Int64) {
        self.name = name
        self.id = id
    }
    
    required init(with resolver: Resolver) throws {
        self.id = try resolver.value("id")
        self.name = try resolver.value("name")
        self.positions = (try? resolver.value("positions")) ?? []
    }
}
