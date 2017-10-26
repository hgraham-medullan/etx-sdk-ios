//
//  TxResponse.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/13/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Default result response for get queries
 */
public class ETXResponse : ETXModel {
    
    var result: Any?
    var meta: ETXResponseMeta?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    required public init() {
        super.init()
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        result <- map["result"]
        meta <- map["meta"]
    }
}
