//
//  CombinedCondition.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Represents a combination of conditions
 */
public class ETXCombinedCondition: ETXCondition {
    
    /**
     The operator to use when combining the condition
    */
    public enum CombineType: String {
        case and = "and"
        case or = "or"
    }
    
    private var combineType: CombineType
    private var conditions: [ETXCondition]
    
    /**
     Create combination of conditions
     - parameter combineType: What operator to use when joining the conditions
     - parameter conditions: An array list of the conditions
    */
    public init(combineType: CombineType, conditions: [ETXCondition]) {
        self.combineType = combineType
        self.conditions = conditions
    }
    
    /**
     Converts the condition to its Dictionary representation
     - returns: The Dictionary representation of the condition
     */
    public func toJson() -> [String : Any] {
        var a = [String: [Any]]()
        var theConditions: [[String: Any]] = [[String: Any]]()
        for c in conditions  {
            theConditions.append(c.toJson())
        }
        a[self.combineType.rawValue] = theConditions
        return a;
    }
}
