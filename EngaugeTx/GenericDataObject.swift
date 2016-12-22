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
 ```
 
 class DoctorVisit: ETXGenericDataObject {
    var visitDate: Date?
 
    override func mapping(map: Map) {
        super.mapping(map: map)
        visitDate <- (map["visitDate"], DateTransform())
    }
 }
 
 
 ```
 */



open class ETXGenericDataObject: ETXModel {
    
    override init() {
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
     Describes how the object should be desearialized
     - parameter map: The data as a Map
     */
    override open func mapping(map: Map) {
        super.mapping(map: map)
    }
    
}
