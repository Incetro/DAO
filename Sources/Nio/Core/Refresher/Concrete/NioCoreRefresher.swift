//
//  NioCoreRefresher.swift
//  Nio
//
//  Created by incetro on 15/07/2017.
//
//

import CoreData
import Reflex

// MARK: - NioCoreRefresher

public class NioCoreRefresher<M, P>: Refresher where M: ManagedModel, M: Model, P: Plain {
    
    public typealias RefreshingModel = M
    public typealias RefreshingPlain = P
    
    // MARK: - Initializers
    
    /// Standard initializer
    
    public init() {
        
        
    }
    
    /// Initializer with model and plain types
    ///
    /// - Parameters:
    ///   - mode: Model type
    ///   - plain: Plain type
    
    public init(model: M.Type, plain: P.Type) {
        
        
    }
    
    // MARK: - Internal
    
    /// Check if property named propertyName in the given object is a collection
    ///
    /// - Parameters:
    ///   - object: Given object
    ///   - propertyName: Property name
    /// - Returns: true if property named propertyName is collection
    
    private func propertyIsCollection(_ object: NSManagedObject, propertyName: String) -> Bool {
        
        guard let value = object.value(forKey: propertyName) else {
            
            return false
        }
        
        if value is NSSet {
            
            return true
        }
        
        if value is NSArray {
            
            return true
        }
        
        if value is [Any] {
            
            return true
        }
        
        return false
    }
    
    /// Check if property named propertyName in the given object is a relationship
    ///
    /// - Parameters:
    ///   - object: Given object
    ///   - propertyName: Property name
    /// - Returns: true if property named propertyName is a relationship
    
    private func propertyIsRelationship(_ object: NSManagedObject, propertyName: String) -> Bool {
        
        return object.entity.relationshipsByName[propertyName] != nil
    }
    
    /// Update subentity by the given property
    ///
    /// - Parameters:
    ///   - object: Object with subentity
    ///   - property: Object with information about subentity
    /// - Throws: Refreshing error
    
    private func refreshSubentity(_ object: NSManagedObject, property: Reflection, ignoredProperties: Set<String>) throws {
        
        guard let relationship = object.entity.relationshipsByName[property.name] else {
            
            throw NioCoreRefresherError.unexistingRelationship(name: property.name, className: String(describing: object.classForCoder))
        }
        
        guard let subentityClassName = relationship.destinationEntity?.managedObjectClassName else {
            
            throw NioCoreRefresherError.cannotObtainDestinationRelationshipName(name: property.name, className: String(describing: object.classForCoder))
        }
        
        guard let clazz: ManagedModel.Type = NSClassFromString(subentityClassName) as? ManagedModel.Type else {
            
            throw NioCoreRefresherError.entityIsNotManaged(name: subentityClassName)
        }
        
        guard let context = object.managedObjectContext else {
            
            throw NioCoreRefresherError.unexistingContext(inObject: String(describing: object.classForCoder))
        }
        
        guard let plain = property.value as? Plain else {
        
            throw NioCoreRefresherError.cannotConvertObjectToPlain(name: property.name)
        }
        
        let model = clazz.init(context: context)
        
        try self.refresh(object: model, from: plain, ignoredProperties: ignoredProperties)
        
        object.setValue(model, forKey: property.name)
    }
    
    private func refreshCollection(_ object: NSManagedObject, property: Reflection, ignoredProperties: Set<String>) throws {
        
        if let relationship = object.entity.relationshipsByName[property.name], let entityName = relationship.destinationEntity?.managedObjectClassName {
            
            let set = NSMutableSet()
            
            guard let plains = property.value as? [Any] else {
                
                throw NioCoreRefresherError.cannotConvertObjectToPlainArray(name: String(describing: type(of: property.value)))
            }
            
            for plainObject in plains {
                
                guard let clazz: ManagedModel.Type = NSClassFromString(entityName) as? ManagedModel.Type else {
                    
                    throw NioCoreRefresherError.entityIsNotManaged(name: entityName)
                }
                
                guard let context = object.managedObjectContext else {
                    
                    throw NioCoreRefresherError.unexistingContext(inObject: String(describing: object.classForCoder))
                }
                
                let instance = clazz.init(context: context)
                
                guard let plain = plainObject as? Plain else {
                    
                    throw NioCoreRefresherError.cannotConvertObjectToPlain(name: property.name)
                }
                
                try self.refresh(object: instance, from: plain, ignoredProperties: ignoredProperties)
                
                set.add(instance)
            }
            
            object.setValue(set, forKey: property.name)
            
        } else {
            
            object.setValue(property.value, forKey: property.name)
        }
    }
    
    private func refresh(object: ManagedModel, from plainObject: Plain, ignoredProperties: Set<String>) throws {
        
        var ignoredProperties = ignoredProperties
        
        let managedObjectPropertyNames = object.propertyNames()
        let plainObjectProperties      = Reflector.reflect(from: plainObject, withAncestorsRequirements: .all)
        
        object.setValue(plainObject.nioID.rawValue, forKey: "nioID")
        
        for propertyName in managedObjectPropertyNames {
            
            if ignoredProperties.contains(propertyName) {
                
                continue
            }
            
            guard let property = plainObjectProperties.children(propertyName) else {
                
                throw NioCoreRefresherError.unexistingPropertyInPlainObject(className: Reflector.reflect(from: plainObject).name, propertyName: propertyName)
            }
            
            if self.propertyIsCollection(object, propertyName: propertyName) {
                
                if let ignoredProperty = object.entity.relationshipsByName[property.name]?.inverseRelationship?.name {
                    
                    ignoredProperties.insert(ignoredProperty)
                }
                
                try self.refreshCollection(object, property: property, ignoredProperties: ignoredProperties)
                
            } else if self.propertyIsRelationship(object, propertyName: propertyName) {
                
                guard let ignoredProperty = object.entity.relationshipsByName[property.name]?.inverseRelationship?.name else {
                    
                    throw NioCoreRefresherError.unexistingInverseRelationship(from: property.name, className: String(describing: object.classForCoder))
                }
                
                ignoredProperties.insert(ignoredProperty)
                
                try self.refreshSubentity(object, property: property, ignoredProperties: ignoredProperties)
                
            } else {
                
                object.setValue(property.value, forKey: propertyName)
            }
        }
    }
    
    // MARK: - Refresher
    
    public func refresh(_ model: M, withPlain plain: P) throws {
        
        try self.refresh(object: model, from: plain, ignoredProperties: [])
    }
}

fileprivate extension NSObject {
    
    func propertyNames() -> Array<String> {
        
        var results: [String] = []
        
        var count: UInt32 = 0
        
        if let properties = class_copyPropertyList(self.classForCoder, &count) {
            
            for i in 0..<count {
                
                if let property = properties[Int(i)] {
                    
                    if let cname = property_getName(property), let name = String(validatingUTF8: cname) {
                        
                        results.append(name)
                    }
                }
            }
            
            free(properties)
            
            return results
        }
        
        return []
    }
}
