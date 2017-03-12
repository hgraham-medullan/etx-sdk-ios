//
//  Steps.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the Steps activity
 */
open class ETXSteps: ETXAggregatableModel {
    
    /**
     The number of steps taken
     */
    public var stepCount: Int?
    
    /**
     The number of calories burned during the activity
     */
    public var caloriesBurned: Float?
    
    /**
     The length of time (in minutes) taken to achieve the stepCount
     */
    public var duration: Int?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        stepCount <- map["stepCount"]
        caloriesBurned <- map["caloriesBurned"]
        duration <- map["duration"]
        
    }
}
