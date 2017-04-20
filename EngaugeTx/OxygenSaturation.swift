//
//  OxygenSaturation.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/18/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXOxygenSaturation: ETXMeasurement {
    
    public var spo2: Float?
    public var spo2Unit: String?
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
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        spo2 <- map["spo2"]
        spo2Unit <- map["spo2Unit"]
        bpm <- map["bpm"]
    }
}
