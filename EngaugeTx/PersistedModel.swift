//
//  PersistedModel.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXPersistedModel: ETXModel {
    
    public var ownerId: String?
    public var updatedBy: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var dateLogged: Date?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        createdAt <- (map["createdAt"], ETXDateTransform())
        updatedAt <- (map["updatedAt"], ETXDateTransform())
        dateLogged <- (map["date"], ETXDateTransform())
        ownerId <- map["ownerId"]
        updatedBy <- map["updatedBy"]
    }
}
