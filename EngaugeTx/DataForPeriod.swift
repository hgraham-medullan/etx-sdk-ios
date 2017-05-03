//
//  DataForPeriod.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXDataForPeriod: ETXMappable{
    public var date: Date?
    public var _nodata: Date?
    
    public var strength: [ETXDose]?
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
        _nodata <- map["_nodata"]
        strength <- map["strength"]
        administrations <- map["administrations"]
        units <- map["units"]
        doses <- map["doses"]
        date <- (map["date"], ETXDateOnlyTransform())
    }
}
