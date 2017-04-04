//
//  MeasurementSource.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 How the values were logged or where they came from
 */
public class ETXMeasurementSource: ETXModel {
    
    /**
     Method for logging air quality measurements.
     */
    var type: String?
    
    /**
     Information about device that recorded the air quality measurements.
     */
    var measurementDevice: ETXMeasurementDevice?
    
    init(type: String, measurementDevice: ETXMeasurementDevice) {
        self.type = type
        self.measurementDevice = measurementDevice
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
    }
    
}
