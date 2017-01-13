//
//  WhereCondition.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

enum ComparatorD: String {
    case between = "between"
}

/**
 REpresents a single condition by which to filter data
 */
public class ETXWhereCondition: ETXCondition {
    
    class Comp {
        var value: Any!
        var comparator: ETXComparator!
        
        init(comparator: ETXComparator, value: Any) {
            self.comparator = comparator
            self.value = value
        }
    }
    
    private var property: String!
    private var comp: Comp!
    
    /**
     Create a new where condition
     - parameter property: The name of the property to compare the value against
     - parameter comparator: The operator to use to compare values
     - parameter value: The value to compare against to find matching results
    */
    public init(property: String, comparator: ETXComparator, value: Any) {
        self.property = property
        self.comp = Comp(comparator: comparator, value: value)
    }
    
//    init(property: String) {
//        self.property = property
//    }
    
//    func between<T: Any>(_ value1: T, and value2:T ) -> Comp {
//        //self.property = prop
//        self.comp = Comp(comparator: .gte, value: value1)
//        return self.comp
//    }

    
    /**
     Converts the condition to its Dictionary representation
     - returns: The Dictionary representation of the condition
     */
    public func toJson() -> [String: Any] {
        var q = [String:Any]()
        if self.comp.comparator == .eq {
            q[self.property] = self.comp.value!
        } else {
            q[self.property] = [self.comp.comparator.rawValue : self.comp.value!]
        }
        return q
    }
}
