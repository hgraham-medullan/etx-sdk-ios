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
public class ETXModel: Mappable {
    
    var id: String? = ""
    
    public init() {
        
    }
    
    /**
     Create an instance from a Map
     */
    required public init?(map: Map) {
        
    }
    
    /**
     This function is where all variable mappings should occur. It is executed
     by Mapper during the mapping (serialization and deserialization) process.
     */
    public func mapping(map: Map) {
        id <- map["id"]
    }
}

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension JSONConvertible
{
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}
