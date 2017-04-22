//
//  DosageFrequency.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXDosageFrequency: ETXMappable{
    public var frequency: Int?
    public var period: Int?
    public var periodUnit: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        frequency <- map["frequency"]
        period <- map["period"]
        periodUnit <- map["periodUnit"]
    }
}
