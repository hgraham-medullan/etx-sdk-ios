//
//  Condtion.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Represents a conditon by which to filter data
 */
public protocol ETXCondition {
    /**
     Converts the condition to its Dictionary representation
     - returns: The Dictionary representation of the condition
     */
    func toJson() -> [String:Any]
}
