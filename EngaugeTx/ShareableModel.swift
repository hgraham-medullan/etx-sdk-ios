//
//  ShareableModel.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//


import Foundation
import ObjectMapper

public protocol ETXSharedModel: ETXPersistableModel {
    typealias ModelType = Self
    init()
    func getDataSvc<M: ETXModel, T: QueryablePersistenceService>(_ forModel: M) -> T
}

/// Model that can be shared among affiliated users
open class ETXShareableModel: ETXPersistedModel, ETXSharedModel {
    
    public var ownerId: String?
    
     override class var modelResourcePath: String? {
        return "/"
    }
    
    public required init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
        ownerId <- map["ownerId"]
    }
    
    public init(owner: ETXUser) {
        super.init()
        self.ownerId = owner.id
    }
}

extension ETXSharedModel where Self: ETXShareableModel  {
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    public static func findById(_ id: String, onBehalfOfUser: ETXUser, completion: @escaping (ModelType?, ETXError?)->Void) {
        let m = Self.init()
        let  ds: ETXShareableModelDataService<ModelType> = m.getDataSvc(m)
        
        ds.findById(id, onBehalfOfUser: onBehalfOfUser) {
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
    public static func findWhere(filter: ETXSearchFilter,  onBehalfOfUser: ETXUser, completion: @escaping ([ModelType]?, ETXError?)->Void) {
        let m = Self.init()
        let  dataSvc: ETXShareableModelDataService<ModelType> = m.getDataSvc(m)
        dataSvc.findWhere(filter, onBehalfOfUser: onBehalfOfUser) {
            (items, err) in
            completion(items, err)
        }
    }
}



