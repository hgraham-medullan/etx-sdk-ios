//
//  PrescriptionDosage.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXPrescriptionDosage: ETXMappable{
    public var asNeeded: Bool?
    public var dose: ETXDose?
    public var timing: ETXTiming?
    public var route: String?
    public var method: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        asNeeded <- map["asNeeded"]
        dose <- map["dose"]
        timing <- map["timing"]
        route <- map["route"]
        method <- map["method"]
    }
}
