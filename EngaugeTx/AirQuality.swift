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
open class ETXAirQuality: ETXMeasurement {
    
    /**
     How polluted the air is
    */
    public var aqi: Float?
    public var pm25: Double?
    public var pm25Unit: String?
    public var co: Int?
    public var coUnit: String?
    public var location: ETXCoords?
    
    override class var trendResultKey: String {
        return "AirQuality"
    }
    
    override class var modelResourcePath: String {
        return "/AirQuality"
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        aqi <- map["aqi"]
        pm25 <- map["pm25"]
        pm25Unit <- map["pm25Unit"]
        co <- map["co"]
        coUnit <- map["coUnit"]
        location <- map["location"]
    }
}
