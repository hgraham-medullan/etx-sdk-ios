//
//  TxModel.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/1/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper

/// Represents a data object stored on the EngaugeTx Platform
open class ETXModel: Mappable {
    
    /**
     The model's ID
    */
    public var id: String? = nil
    
    var rawJson: [String:Any]?
    
    func getDataSvc<T: ETXDataService<ETXModel>>() -> T {
        fatalError("Data service not defined for model")
    }
    
    var dataSvc: ETXDataService<ETXModel>!
    
    public init() {
        
    }
    
//    init(_ dataSvc: ETXDataService<ETXModel>) {
//        self.dataSvc = dataSvc
//    }
    
    /**
     Create an instance from a Map
     - parameter map: The Map object
     */
    required public init?(map: Map) {
        self.rawJson = map.JSON
    }
    
    /**
     This function is where all variable mappings should occur. It is executed
     by Mapper during the mapping (serialization and deserialization) process.
     */
    open func mapping(map: Map) {
        id <- map["id"]
    }
    
    public func save(completion: @escaping (ETXError?) -> Void) {
        self.getDataSvc().save(model: self) {
            (model, err) in
            if let model = model {
                let map = Map(mappingType: .fromJSON, JSON: model.rawJson!)
                self.mapping(map: map)
            }
            completion(err)
        }
        
    }
}
