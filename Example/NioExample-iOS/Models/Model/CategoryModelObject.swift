//
//  CategoryModelObject.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

import NIO
import CoreData

// MARK: - CategoryModelObject

class CategoryModelObject: ManagedModel {
    
    @NSManaged var name: String
    @NSManaged var id: Int64
    @NSManaged var positions: NSSet
}
