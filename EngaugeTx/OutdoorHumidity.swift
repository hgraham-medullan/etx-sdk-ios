//
//  OutdoorHumidity.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 * Represents a measure of outdoor relative humidity
 */
open class ETXOutdoorHumidity: ETXAggregatableModel {
    
    /**
     * The percentage of water vapor the air is holding
     */
    public var level: Float?

    override open func mapping(map: Map) {
        super.mapping(map: map)
        level <- map["level"]
    }
}
