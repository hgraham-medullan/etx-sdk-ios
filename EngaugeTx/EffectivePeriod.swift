//
//  EffectivePeriod.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXEffectivePeriod: ETXMappable{
    public var start: Date?
    public var end: Date?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        end <- (map["end"], ETXDateTransform())
        start <- (map["start"], ETXDateTransform())
    }
}
