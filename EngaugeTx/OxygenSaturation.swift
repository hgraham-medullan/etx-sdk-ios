//
//  OxygenSaturation.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/18/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Represents the percentage of hemoglobin binding sites in the bloodstream occupied by oxygen
 */
open class ETXOxygenSaturation: ETXMeasurement {
    
    /**
     The blood oxygen saturation level
     */
    public var spo2: Float?
    
    /**
     Unit for capillary oxygen saturation.
     */
    public var spo2Unit: String?
    
    /**
     Heart pulse
     */
    public var bpm: Int?
    
    override open class var trendResultKey: String {
        return "OxygenSaturation"
    }
    
    override class var modelResourcePath: String {
        return "/OxygenSaturation"
    }
    
    public init(spo2: Float,spo2Unit: String, bpm: Int){
        super.init()
        self.spo2 = spo2
        self.spo2Unit = spo2Unit
        self.bpm = bpm
        self.source = ETXMeasurementSource()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public required init() {
        super.init()
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        spo2 <- map["spo2"]
        spo2Unit <- map["spo2Unit"]
        bpm <- map["bpm"]
    }
    
    public override func getDataSvc<M: ETXOxygenSaturation, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let repository = ETXShareableModelRespository<M>(resourcePath: "/OxygenSaturation")
        let defaultDataSvc = ETXShareableModelDataService<M>(repository: repository)
        return defaultDataSvc as! T
    }
}
