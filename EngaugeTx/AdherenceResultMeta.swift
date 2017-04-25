//
//  AdherenceResultMeta.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/24/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXAdherenceResultMeta: ETXMappable{
    public var agg: String?
    public var bucketSize: ETXBucketSize?
    public var field: String?
    public var groupBy: String?
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        agg <- map["agg"]
        bucketSize <- map["bucketSize"]
        field <- map["field"]
        groupBy <- map["groupBy"]
    }
}
