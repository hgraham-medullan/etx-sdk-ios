//
//  AggregatableModel.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents an aggregated data set
 */
open class ETXAggregatableModel: ETXGenericDataObject, ETXAggregatable {

    internal class var trendResultKey: String? {
        return  nil
    }
    
    /**
     The aggregated value
    */
    public var value: Double?
    
    /**
     The date for which the value was aggregated
    */
    public var date: Date?
    
    /**
     The number of records aggregated
    */
    public var count: Int?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        value <- map["value"]
        count <- map["count"]
        date <- (map["date"], ETXDateOnlyTransform())
    }
}

protocol ETXAggregatable {
    static var trendResultKey: String? { get }
    var value: Double? {get set}
    var date: Date? {get set}
    var count: Int? {get set}
}

extension ETXAggregatable where Self: ETXAggregatableModel {
    internal static var resultKey: String {
        var _trendResultKey: String = String(describing: self)
        if self.trendResultKey != nil {
            _trendResultKey = self.trendResultKey!
        }
        
        return _trendResultKey
    }
}
