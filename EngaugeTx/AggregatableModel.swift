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
    
    public override init() {
        super.init()
    }
    
    public required init?(map: Map) {
        super.init(map: map)
        value = try? map.value("value")
        count = try? map.value("count")
        _nodata = try? map.value("_nodata")
        //   date = (map.value("date"), ETXDateOnlyTransform())
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
//        value <- map["value"]
//        count <- map["count"]
//        _nodata <- map["_nodata"]
//        date <- (map["date"], ETXDateOnlyTransform())
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
