//
//  GenericDataService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/15/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

class GenericDataObjectRepository<T: ETXGenericDataObject> : Repository<T> {
    init(className: String) {
        
        super.init(resourcePath: "/data/class/\(className)")
        
    }
}

open class ETXDataService <T: ETXModel> {
    
    var repository: Repository<T>
    
    init(repository: Repository<T>) {
        self.repository = repository
    }
    
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    public func findById(_ id: String, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        self.repository.getById(id, completion: completion)
    }
    
    func findWhere(completion: @escaping ([T]?, ETXError?) -> Void) {
        
    }
    
    /**
     Delete a model
     - parameter model: The model to be deleted
     - parameter completion: Callback when the request completes
     - parameter err: If an error occurred while deleting the item
     */
    public func delete(model: T, completion: (ETXError?) -> Void) {
        guard let modelId = model.id, modelId.isEmpty != true else {
            completion(ETXError())
            return
        }
        self.repository.delete(model: model, completion: completion)
    }
    
    /**
     Save a model
     - parameter model: The model to be saved
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while savinga the item
     */
    public func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        self.repository.save(model: model, completion: completion)
    }
}

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
    
}
