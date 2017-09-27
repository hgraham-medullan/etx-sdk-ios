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
open class ETXAggregatableModel: ETXPersistedModel, ETXAggregatable {
    
    override class var modelResourcePath: String? {
        return "/"
    }
    
    open class var trendResultKey: String? {
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
    public var _nodata: Bool?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        value <- ignoreOnNull("value", map:map)
        count <- ignoreOnNull("count", map:map)
        _nodata <- ignoreOnNull("_nodata", map:map)
        date <- ignoreOnNull("date", map: map, transformType: ETXDateOnlyTransform())
    }
    
    override open class func getDataSvc<ETXAggregatableModel>() -> ETXDataService<ETXAggregatableModel>? {
        return nil
    }
}

/**
 
 */
protocol ETXAggregatable : ETXPersistableModel{
    static var trendResultKey: String? { get }
    //static var modelResourcePath: String? { get }
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

extension ETXAggregatable where Self: ETXAggregatableModel {
    internal static var resourcePath: String {
        var _modelResourcePath: String = String(describing: self)
        if self.modelResourcePath != nil {
            _modelResourcePath = self.modelResourcePath!
        }
        
        return _modelResourcePath
    }
}
