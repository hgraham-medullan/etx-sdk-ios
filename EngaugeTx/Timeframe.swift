//
//  Timeframe.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/12/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Timeframe for which to analyse a trend
 */
public enum ETXTrendTimeframe: Int {
    
    /**
     One Week
     */
    case OneWeek = 7
    
    /**
     Two Weeks
     */
    case TwoWeeks = 14
    
    /**
     One month (30 days)
     */
    case OneMonth = 30
}

/**
 Represent aggregated data about the Trend's timeframe
 */
public class ETXTimeframe: ETXModel {
    
    /**
     The start date of the trend
     */
    public var startDate: Date?
    
    /**
     The end date of the trend
     */
    public var endDate: Date?
    
    /**
     The count of the entries
     */
    public var count: Int?
    
    /**
     The sum of the values over the timeframe
     */
    public var sum: Double?
    
    /**
     The average of the values over the timeframe
     */
    public var average: Double?
    
    /**
     The last value logged
     */
    public var lastValue: Double?
    
    /**
     The date the last value was logged
     */
    public var lastDate: Date?
    
    init(startDate: Date, endDate: Date) {
        super.init()
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(trendTimeframe: ETXTrendTimeframe ) {
        super.init()
        self.setStartDate(trendTimeframe: trendTimeframe, leadingUpTo: Date());
    }
    
    init( trendTimeframe: ETXTrendTimeframe,  leadingUpTo: Date) {
        super.init()
        self.setStartDate(trendTimeframe: trendTimeframe, leadingUpTo: leadingUpTo);
    }
    
    func setStartDate(trendTimeframe: ETXTrendTimeframe, leadingUpTo: Date) {
        self.endDate = leadingUpTo;
        var startDate = DateService.subtractTimeframe(timeframe: trendTimeframe, date: leadingUpTo)
        startDate = DateService.setToMidnight(startDate)
        self.startDate = startDate
    }
    
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
        startDate <- map["startDate"]
        endDate  <- map["endDate"]
        sum <- map["sum"]
        count <- map["count"]
        average <- map["avg"]
        lastValue <- map["lastValue"]
        lastDate <- (map["lastDate"], ETXDateTransform())
    }
}
