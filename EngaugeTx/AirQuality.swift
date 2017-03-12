//
//  AirQuality.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents quality of air and it level of pollution
 */
open class ETXAirQuality: ETXAggregatableModel {
    
    /**
     How polluted the air is
    */
    public var airQualityIndex: Float?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        airQualityIndex <- map["airQualityIndex"]
    }
}
