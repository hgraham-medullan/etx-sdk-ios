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
    
    /**
     Measure of the levels of Sulphur dioxide (SO2) in the air.
     */
    public var so2: Double?
    
    /**
     Unit for Sulphur dioxide.
     */
    public var so2Unit: String?
    
    /**
     Measure of the levels of Nitrogen dioxide (NO2) in the air.
     */
    public var no2: Double?
    
    /**
     Unit for Nitrogen dioxide.
     */
    public var no2Unit: String?
    
    /**
     Measure of the ground-level ozone.
     */
    public var ozone: Int?
    
    /**
     Unit for ground-level ozone.
     */
    public var ozoneUnit: String?
    
    override open class var trendResultKey: String {
        return "OutdoorAirQuality"
    }
    override class var modelResourcePath: String {
        return "/OutdoorAirQuality"
    }
    
//    open override class func getDataSvc<ETXSteps>() -> ETXDataService<ETXSteps>? {
//        return ETXDataService<ETXSteps>(repository: Repository<ETXSteps>(resourcePath: "/steps"), modelType: ETXSteps.self, typeAsString: String(describing: ETXSteps.self))
//    }
    
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
