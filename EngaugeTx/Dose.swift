//
//  Dose.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXDose: ETXMappable{
    public var value: Int?
    public var unit: String?
    
    public init(value: Int, unit: String) {
        super.init()
        self.value = value
        self.unit = unit
    }
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        value <- map["value"]
        unit <- map["unit"]
    }
}
