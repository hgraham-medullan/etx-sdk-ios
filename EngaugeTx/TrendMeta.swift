//
//  TrendMeta.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/18/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

public class ETXTrendMeta: ETXModel {
    public var groupBy: String?
    public var bucketSize: String?
    public var field: String?
    public var agg: String?
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        groupBy <- map["groupBy"]
        bucketSize  <- map["bucketSize"]
        field <- map["field"]
        agg <- map["agg"]
    }
}
