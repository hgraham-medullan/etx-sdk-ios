//
//  AdherenceResultSet.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXAdherenceResultSet: ETXMappable{
    public var medication: ETXMedication?
    public var prescription: ETXPrescription?
    public var periods: [ETXDataForPeriod]?
    public var timeframe: ETXAdherenceTimeFrame?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        medication <- map["medication"]
        prescription <- map["prescription"]
        periods <- map["periods"]
        timeframe <- map["timeframe"]
    }
}
