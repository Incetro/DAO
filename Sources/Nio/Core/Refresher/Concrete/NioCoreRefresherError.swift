//
//  NioCoreRefresherError.swift
//  Nio
//
//  Created by incetro on 17/07/2017.
//
//

import Foundation

// MARK: - NioCoreRefresherError

internal enum NioCoreRefresherError: LocalizedError {
    
    case entityIsNotManaged(name: String)
    case unexistingContext(inObject: String)
    case cannotConvertObjectToPlain(name: String)
    case cannotConvertObjectToPlainArray(name: String)
    case unexistingRelationship(name: String, className: String)
    case unexistingInverseRelationship(from: String, className: String)
    case cannotObtainDestinationRelationshipName(name: String, className: String)
    case unexistingPropertyInPlainObject(className: String, propertyName: String)
    
    var localizedDescription: String {
        switch self {
        case .unexistingRelationship(name: let name, className: let className):
            return "NioCoreRefresher cannot get relationship '\(name)' in class '\(className)'"
        case .unexistingInverseRelationship(from: let name, className: let className):
            return "NioCoreRefresher cannot get inverse relationship from '\(name)' in class '\(className)'"
        case .cannotObtainDestinationRelationshipName(name: let name, className: let className):
            return "NioCoreRefresher cannot get class name for relationship named '\(name)' in class '\(className)'"
        case .entityIsNotManaged(name: let name):
            return "NioCoreRefresher cannot create ManagedModel class type from '\(name)' class"
        case .unexistingContext(inObject: let className):
            return "NioCoreRefresher cannot obtain NSManagedObjectContext from class named '\(className)'"
        case .cannotConvertObjectToPlain(name: let name):
            return "NioCoreRefresher cannot convert '\(name)' class to 'Plain'"
        case .cannotConvertObjectToPlainArray(name: let name):
            return "NioCoreRefresher cannot convert '\(name)' class to 'Array<Plain>'"
        case .unexistingPropertyInPlainObject(className: let className, propertyName: let propertyName):
            return "NioCoreRefresher cannot obtain property '\(propertyName)' in class named '\(className)'"
        }
    }
}
