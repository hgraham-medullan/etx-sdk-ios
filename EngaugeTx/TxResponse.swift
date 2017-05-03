//
//  TxResponse.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/13/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper


public class ETXResponse : ETXModel {
    
    var result: Any?
    var meta: ETXResponseMeta?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        result <- map["result"]
        meta <- map["meta"]
    }
}
