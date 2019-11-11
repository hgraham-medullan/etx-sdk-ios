//
//  ClassTrendResultSet.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/12/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the trend for a single Model/Class
 */
public class ETXClassTrendResultSet: ETXModel {
    /**
     Aggregated values for each day over the timeframe
     */
    public var values:[ETXAggregatableModel]?
    
    /**
     Aggregated data about the trend over the timeframe
     */
    public var timeframe: ETXTimeframe?
    public var className: String?
    public var meta: ETXTrendMeta?
    
    /**
     Create an instance from a Map
     - parameter map: The Map object
     */
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    required public init() {
        super.init()
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        values <- map["values"]
        timeframe <- map["timeframe"]
        className <- map["class"]
        meta <- map["meta"]
    }
}
