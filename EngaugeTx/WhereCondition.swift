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

class WhereCondition: Condition {
    
    class Comp {
        var value: Any!
        var comparator: Comparator!
        
        init(comparator: Comparator, value: Any) {
            self.comparator = comparator
            self.value = value
        }
    }
    
    private var property: String!
    private var comp: Comp!
    
    init(property: String, comparator: Comparator, value: Any) {
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

    
    func toJson() -> [String: Any] {
        var q = [String:Any]()
        if self.comp.comparator == .eq {
            q[self.property] = self.comp.value
        } else {
            q[self.property] = [self.comp.comparator.rawValue : self.comp.value]
        }
        return q
    }
}
