//
//  Usage.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXUsage: ETXMappable{
    public var label: String?
    public var doses: Int?
    public var tod: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public init(label: String, doses: Int, tod: String) {
        super.init()
        self.label = label
        self.doses = doses
        self.tod = tod
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        label <- map["label"]
        doses <- map["doses"]
        tod <- map["tod"]
    }
}
