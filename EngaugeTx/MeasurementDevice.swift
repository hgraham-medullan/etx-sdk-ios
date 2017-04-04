//
//  MeasurementDevice.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Device used to record measurements
 */
public class ETXMeasurementDevice: ETXModel {
    
    init(id: String) {
        super.init()
        self.id = id
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
    }
}
