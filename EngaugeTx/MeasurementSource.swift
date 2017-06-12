//
//  MeasurementSource.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 How or where the measurement was captured
 */
open class ETXMeasurementSource: ETXMappable {
    
    public var type: String?;
    public var device: ETXMeasurementDevice?
    
    public init(type: String, device: ETXMeasurementDevice) {
        super.init()
        self.type = type
        self.device = device
    }
    
    public override init() {
        super.init()
        self.device = ETXMeasurementDevice()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        device <- map["device"]
        type <- map["type"]
    }
}
