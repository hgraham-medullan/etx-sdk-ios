//
//  MeasurementDevice.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 The device that was used to capture a measurement
 */
open class ETXMeasurementDevice: ETXModel {
    public init(deviceId: String){
        super.init()
        self.id = deviceId
    }
    public required init(){
        super.init()
    }
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
    }
}
