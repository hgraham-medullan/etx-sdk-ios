//
//  Medication.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXMedication: ETXShareableModel {
    public var tradeName: String?
    public var form: String?
    public var strength: [ETXDose]?
    
    public required init() {
        super.init()
    }
    
    override class var modelResourcePath: String {
        return "/med/data/medications"
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        tradeName <- map["tradeName"]
        form <- map["form"]
        strength <- map["strength"]
    }
}
