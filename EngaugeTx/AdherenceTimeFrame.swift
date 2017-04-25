//
//  AdherenceTimeFrame.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXAdherenceTimeFrame: ETXMappable{
    public var startDate: Date?
    public var endDate: Date?
    public var lastDate: Date?
    public var strength: [ETXDose]?
    public var periods: Int?
    public var administrations: ETXAdherenceValue?
    public var units: ETXAdherenceValue?
    public var doses: ETXAdherenceValue?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        periods <- map["periods"]
        administrations <- map["administrations"]
        units <- map["units"]
        doses <- map["doses"]
        strength <- map["strength"]
        endDate <- (map["endDate"], ETXDateTransform())
        startDate <- (map["startDate"], ETXDateTransform())
        lastDate <- (map["lastDate"], ETXDateTransform())
    }
}
