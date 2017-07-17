//
//  AdditiveModelObject.swift
//  Nio
//
//  Created by incetro on 16/07/2017.
//
//

import NIO
import CoreData

// MARK: - AdditiveModelObject

class AdditiveModelObject: ManagedModel {
    
    @NSManaged var name: String
    @NSManaged var id: Int64
    @NSManaged var price: Double
    @NSManaged var position: PositionModelObject?
}
