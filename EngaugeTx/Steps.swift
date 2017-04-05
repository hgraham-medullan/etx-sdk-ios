//
//  Steps.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

class MeasurementService<M: ETXMeasurement>: ETXDataService<M> {
    init(_ path: String) {
        var repo = Repository<M>(resourcePath: path)
        super.init(repository: repo)
    }
}

/**
 Represents the Steps activity
 */
open class ETXSteps: ETXMeasurement, FirstClassModel {
    
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
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
     override class func getDataSvc() -> ETXDataService<ETXPersistentModel>? {
        return nil //MeasurementService<ETXSteps>("") as! T
        //return ETXDataService<ETXSteps>(repository: Repository<ETXSteps>(resourcePath: "/steps"))
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        stepCount <- map["steps"]
        caloriesBurned <- map["calories"]
        duration <- map["duration"]
    }
}
