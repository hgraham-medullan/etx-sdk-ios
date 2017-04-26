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
    
    /**
     Measure of the level of particle pollution in an area where particles (mixture of solid
     and/or liquid suspended in the air) are 2.5 micrometers in diameter or smaller.
     */
    public var pm25: Double?
    
    /**
     Unit for pm25
     */
    public var pm25Unit: String?
    
    /**
     Measure of the levels of Carbon monoxide (CO) in the air.
     */
    public var co: Int?
    
    /**
     Unit for Carbon monoxide.
     */
    public var coUnit: String?
    
    /**
     Where the air quality measurements were taken
     */
    public var location: ETXCoords?
    
    override open class var trendResultKey: String {
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
