//
//  OutdoorAirQuality.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the measure of ambient air quality
 */
open class ETXOutdoorAirQuality: ETXAirQuality {
    
    public var so2: String?
    public var so2Unit: Double?
    public var no2: String?
    public var no2Unit: Double?
    public var ozone: String?
    public var ozoneUnit: Double?
    
    override class var trendResultKey: String {
        return "OutdoorAirQuality"
    }
    override class var modelResourcePath: String {
        return "/OutdoorAirQuality"
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        so2 <- map["so2"]
        so2Unit <- map["so2Unit"]
        no2 <- map["no2"]
        no2Unit <- map["no2Unit"]
        ozone <- map["ozone"]
        ozoneUnit <- map["ozoneUnit"]
    }
}
