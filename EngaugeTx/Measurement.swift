//
//  Measurement.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Value(s) that can be captured from a source device and can be aggregated on
 */
open class ETXMeasurement: ETXAggregatableModel {
    
    public var source: ETXMeasurementSource?
    
    public override init() {
        super.init()
        self.date = Date()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        source <- map["source"]
    }
    
    open override class func getDataSvc<T: ETXMeasurement>() -> ETXDataService<T>? {
        return nil
    }
    
}
