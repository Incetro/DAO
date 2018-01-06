//
//  PositionModelObject.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

import CoreData

// MARK: - PositionModelObject

class PositionModelObject: ManagedModel {
    @NSManaged var name: String
    @NSManaged var id: Int64
    @NSManaged var price: Double
    @NSManaged var category: CategoryModelObject?
    @NSManaged var additives: NSSet
}
