//
//  GenericDataObject.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/14/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Use Generic Data Objects to store data that is unique to your application
 */
open class ETXGenericDataObject: ETXModel {
    
    override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    /**
     Describes how the object should be desearialized
     - parameter map:
     */
    override open func mapping(map: Map) {
        super.mapping(map: map)
    }
    
}
