//
//  NioTranslator.swift
//  Nio
//
//  Created by incetro on 14/07/2017.
//
//

import Transformer

// MARK: - NioTranslator

/// Standard translator of `Nio framework`.
/// This translator use `Transformer framework` for universal mapping from
/// database models to plain objects.
/// So, if you don't like this class, you can implement `Translator`
/// protocol for your entities and use it.
public class NioTranslator<M: Model, P: TransformablePlain>: Translator {
    
    public typealias TranslatingModel = M
    public typealias TranslatingPlain = P
    
    // MARK: - Properties
    
    /// Transformer instance
    private let transformer: Transformer
    
    // MARK: - Initializers
    
    /// Initializer with tranformer instance
    ///
    /// - Parameter transformer: Transformer instance
    public init(transformer: Transformer) {
        self.transformer = transformer
    }
    
    /// Initializer with tranformer instance and model/plain types
    ///
    /// - Parameters:
    ///   - transformer: Transformer instance
    ///   - model: database model type
    ///   - plain: plain object type
    public init(transformer: Transformer, model: M.Type, plain: P.Type) {
        self.transformer = transformer
    }
    
    /// Initializer with transform type
    ///
    /// - Parameter transformType: transform type (coredata, realm)
    public init(withTransformType transformType: MappingType) {
        self.transformer = Transformer(from: transformType)
    }
    
    /// Initializer with tranform type and model/plain types
    ///
    /// - Parameters:
    ///   - transformType: transform type (coredata, realm)
    ///   - model: database model type
    ///   - plain: plain object type
    public init(withTransformType transformType: MappingType, model: M.Type, plain: P.Type) {
        transformer = Transformer(from: transformType)
    }
    
    // MARK: - Translator
    
    public func translate(model: M) throws -> P {
        return try self.transformer.transform(from: model)
    }
}
