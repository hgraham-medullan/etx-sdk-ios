//
//  OxygenSaturation.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXOxygenSaturation: ETXMeasurement, FirstClassModel {
    
    /**
     The blood oxygen saturation level
     */
    public var spO2: Float?
    
    /**
     Unit for capillary oxygen saturation.
     */
    public var spo2Unit: String?
    
    /**
     Heart pulse
     */
    public var bpm: Int?
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        spO2 <- map["sp02"]
        spo2Unit <- map["spo2Unit"]
        bpm <- map["bpm"]
    }
    
}
