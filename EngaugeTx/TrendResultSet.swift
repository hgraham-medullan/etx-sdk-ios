//
//  TrendResultSet.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/12/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Contains trend result for a set of Models
 */
public class ETXTrendResultSet {
    
    /**
     The collection of trends for the specified classes
     */
    public var classTrends: [String: ETXClassTrendResultSet]
    
    init() {
        self.classTrends = [String: ETXClassTrendResultSet]()
        
    }
    
    /**
     Get the trend for a specific class
     - parameter classType: The type of the class
     */
    public func getTrendForClass(_ classType: ETXAggregatableModel.Type) -> ETXClassTrendResultSet? {
        let key: String = classType.resultKey
        return self.classTrends[key]
    }
    
    public func getClassSummary(_ classType: ETXAggregatableModel.Type) -> ETXClassTrendResultSet? {
        return getTrendForClass(classType)
    }
}
