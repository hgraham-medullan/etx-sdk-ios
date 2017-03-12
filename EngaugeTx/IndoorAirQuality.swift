//
//  IndoorAirQuality.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the measure of household air quality
 **/
open class ETXIndoorAirQuality: ETXAirQuality {
    
    override class var trendResultKey: String {
        return "indoorAirQuality"
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
    }
}
