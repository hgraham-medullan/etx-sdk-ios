//
//  ShareableModel.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//


import Foundation
import ObjectMapper

/// Model that can be shared among affiliated users
open class ETXShareableModel: ETXPersistedModel {
    
     override class var modelResourcePath: String? {
        return "/"
    }
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
    }
}



