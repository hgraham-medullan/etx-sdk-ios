//
//  AdherenceValue.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXAdherenceValue: ETXMappable{
    public var taken: Int?
    public var expected: Int?
    public var adherencePercentage: Double?
    public var average: Double?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        taken <- map["taken"]
        expected <- map["expected"]
        adherencePercentage <- map["adherencePercentage"]
        average <- map["average"]
    }
}
