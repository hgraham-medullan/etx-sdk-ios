//
//  GenericDataObjectConfiguration.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

public class ETXGenericDataObjectConfiguration {
    
    public var dateField: String?
    public var trendField: String?
    public var trend: ETXTrendAggregation?
    
    public init(){
        
    }
    
    public init(dateField: String, trendField: String, trend: ETXTrendAggregation) {
        self.dateField = dateField;
        self.trendField = trendField;
        self.trend = trend;
    }
    
}
