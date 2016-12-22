//
//  GenericDataService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/15/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Provides the ability to manage Generic Data Objects
 */
open class GenericDataService<T: ETXGenericDataObject>: ETXDataService<T> {
    var modelName: String
    
    /**
     Create an instance GenericDataService with a custom model name
     - parameter modelName: The custom name for the model
     */
    init(modelName: String) {
        self.modelName = modelName
        super.init(repository: GenericDataObjectRepository<T>(className: self.modelName))
    }
    
    /**
     Create an instance GenericDataService
     */
    convenience init() {
        self.init(modelName: String(describing: T.self))
    }
    
    override public func findById(_ id: String, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        super.findById(id) {
            (model, err) in
            self.extractFromResultProperty(model, err, completion)
        }
    }
    
    override public func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        if let _ = model.id {
            super.save(model: model) {
                (model, err) in
                self.extractFromResultProperty(model, err, completion)
            }
        } else {
            super.save(model: model, completion: completion)
        }
    }
    
    private func extractFromResultProperty(_ model: T?, _ err: ETXError?, _ completion: @escaping (T?, ETXError?) -> Void) {
        if let model: ETXModel = (model as? ETXModel), let result = model.rawJson?["result"] {
            let m = Mapper<T>().map(JSON: result as! [String : Any])
            completion(m, err)
        } else {
            completion(model, err)
        }
    }

    
}
