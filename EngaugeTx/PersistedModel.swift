//
//  PersistedModel.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//
import Foundation
import ObjectMapper

/// Defines the rules for persisting to the platform
public protocol ETXPersistableModel: ETXModelable {
    typealias ModelType = Self
    
    init()

    func getDataSvc<M: ETXModel, T: QueryablePersistenceService>(_ forModel: M) -> T
}

/// A model that can be stored on the platform
open class ETXPersistedModel : ETXModel, ETXPersistableModel {

    
    private var dataSvc: ETXDataService<ModelType>

    class var modelResourcePath: String? {
        return nil
    }
    
    override public required init() {
        self.dataSvc = ETXDataService<ModelType>()
        super.init()
    }
    
    required public init?(map: Map) {
        self.dataSvc = ETXDataService<ModelType>()
        super.init(map: map)
    }
    
    public func getDataSvc<M: ETXModel, T: QueryablePersistenceService>(_ forModel: M) -> T {
        return self.dataSvc as! T
    }
    
    open override func mapping(map: Map) {
        super.mapping(map:map)
    }
    
    /**
     Save the model. Properties will be updated with new values where applicable
     - parameter completion: Callback when the request completes
     - parameter err: If an error occurred while savinga the item
     */
    public func save(completion: @escaping (ETXError?) -> Void) {
        let  dataSvc: ETXDataService<ModelType> = self.getDataSvc(self)
        dataSvc.save(model: self) {
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
        let  ds: ETXDataService<ModelType> = self.getDataSvc(self)
        ds.delete(model: self) {
            (err) in
            if err == nil {
                self.id = nil
            }
            completion(err)
        }
    }
    
    

}

extension ETXPersistableModel where Self: ETXPersistedModel  {
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    public static func findById(_ id: String, completion: @escaping (ModelType?, ETXError?)->Void) {
        let m = Self.init()
        let  ds: ETXDataService<ModelType> = m.getDataSvc(m)
        
        ds.findById(id) {
            (objectResult, err) in
            guard let objectResult = objectResult else {
                completion(nil, err)
                return
            }
            if let rawJson = objectResult.rawJson, let result = (rawJson["result"] as? [String: Any]) {
                completion(Mapper<ModelType>().map(JSON: result), nil)
            } else {
                completion((objectResult), err)
            }
        }
    }
    
    /**
     Find all elements matching the filter condition(s)
     - parameter filter: Filter to apply to the query
     - parameter completion: Callback when the request completes
     - parameter models: Models of the specified type. Will be ```nil``` if an error occurred
     - parameter err: If an error occurred while getting all items. Will be ```nil``` if get all was successful
     */
    public static func findWhere(filter: ETXSearchFilter, completion: @escaping ([ModelType]?, ETXError?)->Void) {
        let m = Self.init()
        let  dataSvc: ETXDataService<ModelType> = m.getDataSvc(m)
        dataSvc.findWhere(filter) {
            (items, err) in
            completion(items, err)
        }
    }
}
