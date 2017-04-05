//
//  Measurement.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

public protocol ETXMeasurable: ETXPersistableModel {
    var source: ETXMeasurementSource? {get set}
}

open class ETXMeasurement: ETXAggregatableModel, ETXMeasurable {
    
    public var source: ETXMeasurementSource?
    
    public override init() {
        super.init()
    }
    
    public init(source: ETXMeasurementSource) {
        self.source = source
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        source <- map["source"]
    }
    
}
