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
public class ETXClassTrendResultSet: Mappable {
    /**
     Aggregated values for each day over the timeframe
     */
    public var values:[ETXAggregatableModel]?
    
    /**
     Aggregated data about the trend over the timeframe
     */
    public var timeframe: ETXTimeframe?
    
    /**
     Create an instance from a Map
     - parameter map: The Map object
     */
    required public init?(map: Map) {
        //self.rawJson = map.JSON
    }
    
    public func mapping(map: Map) {
        values <- map["values"]
        timeframe <- map["timeframe"]
    }
}
