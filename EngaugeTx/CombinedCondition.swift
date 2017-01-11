//
//  CombinedCondition.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
class CombinedCondition: Condition {
    
    enum CombineType: String {
        case and = "and"
        case or = "or"
    }
    
    private var combineType: CombineType
    private var conditions: [Condition]
    
    init(combineType: CombineType, conditions: [Condition]) {
        self.combineType = combineType
        self.conditions = conditions
    }
    
    internal func toJson() -> [String : Any] {
        var a = [String: [Any]]()
        var theConditions: [[String: Any]] = [[String: Any]]()
        for c in conditions  {
            theConditions.append(c.toJson())
        }
        a[self.combineType.rawValue] = theConditions
        return a;
    }
}
