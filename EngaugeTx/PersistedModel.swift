//
//  PersistedModel.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ETXPersistableModel: ETXModelable {
        typealias ModelType = Self
    
}

open class ETXPersistentModel : ETXModel, ETXPersistableModel {
    typealias ModelType = ETXPersistentModel

    
    
    class func getDataSvc() -> ETXDataService<ETXPersistentModel>? {
        return  nil
    }
    
    open override func mapping(map: Map) {
        super.mapping(map:map)
    }
}

public extension ETXPersistableModel where Self: ETXPersistentModel {
    
        public static func getDataSvc() -> ETXDataService<Self> {
            return ETXDataService<Self>(repository: Repository<Self>(resourcePath: "/data/class"))
        }
    
//    typealias Model = Self
    
//    var dataSvc: ETXDataService<ETXPersistentModel> {
//        return try! ETXGenericDataService<ETXGenericDataObject>(modelName: getModelName())
//    }
    
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    public static func findById(_ id: String, completion: @escaping (ETXPersistentModel?, ETXError?)->Void) {
        Self.getDataSvc()?.findById(id, completion: completion)
    }
    
    /**
     Find all elements matching the filter condition(s)
     - parameter filter: Filter to apply to the query
     - parameter completion: Callback when the request completes
     - parameter models: Models of the specified type. Will be ```nil``` if an error occurred
     - parameter err: If an error occurred while getting all items. Will be ```nil``` if get all was successful
     */
    public static func findWhere(filter: ETXSearchFilter, completion: @escaping ([ETXPersistentModel]?, ETXError?)->Void) {
        let ds = Self.getDataSvc();
        ds?.findWhere(filter, completion: completion)
    }
    
    /**
     Save the model. Properties will be updated with new values where applicable
     - parameter completion: Callback when the request completes
     - parameter err: If an error occurred while savinga the item
     */
    public func save(completion: @escaping (ETXError?) -> Void) {
        
        Self.getDataSvc()?.save(model: self) {
            (model, err) in
            if let model = model {
                let map = Map(mappingType: .fromJSON, JSON: model.rawJson!)
                self.mapping(map: map)
            }
            completion(err)
        }
    }
    
    /**
     Delete the current model
     - parameter completion: Callback when the request completes
     - parameter err: If an error occurred while deleting the item
     */
    public func delete(completion: @escaping (ETXError?) -> Void) {
        Self.getDataSvc()?.delete(model: self) {
            (err) in
            if err == nil {
                self.id = nil
            }
            completion(err)
        }
    }
    
}
