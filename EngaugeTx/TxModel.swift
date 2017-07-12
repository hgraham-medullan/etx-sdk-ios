//
//  TxModel.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/1/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ETXModelable:  Mappable {
    var id: String? { get set}
    var rawJson: [String:Any]? { get set}
}

/// Represents a data object stored on the EngaugeTx Platform
open class ETXModel: ETXMappable {
    
    /**
     The model's ID
    */
    public var id: String? = nil
    
    public override init() {
        super.init()
    }

    
    /**
     Create an instance from a Map
     - parameter map: The Map object
     */
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    /**
     This function is where all variable mappings should occur. It is executed
     by Mapper during the mapping (serialization and deserialization) process.
     */
    open override func mapping(map: Map) {
        id <- ignoreOnNull("id", map: map)
    }
}


