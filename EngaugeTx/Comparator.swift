//
//  Comparator.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 The operator to be used when comparing values
 */
public enum ETXComparator: String {
    
    /**
     Where one value is greater than to the other
     */
    case gt = "gt"
    
    /**
     Where one value is greater than or equal to the other
     */
    case gte
    
    /**
     Where one value is less than to the other
     */
    case lt
    
    /**
     Where one value is less than or equal to the other
     */
    case lte
    
    /**
     Whether two values are equal
     */
    case eq
}
