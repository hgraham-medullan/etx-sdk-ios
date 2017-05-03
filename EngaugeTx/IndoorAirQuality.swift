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
    public var voc: Int?
    public var vocUnit: String?
    public var pm10: Double?
    public var pm10Unit: String?
    public var co2: Double?
    public var co2Unit: String?
    public var temp: Double?
    public var tempUnit: String?
    public var humidity: Double?
    public var humidityUnit: String?
    
    override open class var trendResultKey: String {
        return "IndoorAirQuality"
    }
    override class var modelResourcePath: String {
        return "/IndoorAirQuality"
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        voc <- map["voc"]
        vocUnit <- map["vocUnit"]
        pm10 <- map["pm10"]
        pm10Unit <- map["pm10Unit"]
        co2Unit <- map["co2Unit"]
        co2 <- map["co2"]
        temp <- map["temp"]
        tempUnit <- map["tempUnit"]
        humidity <- map["humidity"]
        humidityUnit <- map["humidityUnit"]
    }
}
