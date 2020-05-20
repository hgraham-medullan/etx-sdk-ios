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
open class ETXOutdoorHumidity: ETXMeasurement {
    
    /**
     * The percentage of water vapor the air is holding
     */
    public var level: Float?
    
    override open class var trendResultKey: String {
        return "OutdoorHumidity"
    }
    
    override class var modelResourcePath: String {
        return "/OutdoorHumidity"
    }

    override open func mapping(map: Map) {
        super.mapping(map: map)
        level <- map["level"]
    }
    
    // ETXOutdoorHumidity
    public override func getDataSvc<M: ETXModel, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let repository = ETXShareableModelRespository<ETXOutdoorHumidity>(resourcePath: "/OutdoorHumidity")
        let defaultDataSvc = ETXShareableModelDataService<ETXOutdoorHumidity>(repository: repository)
        return defaultDataSvc as! T
    }
}
