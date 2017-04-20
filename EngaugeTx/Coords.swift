//
//  Coords.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/20/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXCoords: ETXMappable {
    
    public var lat: Float?
    public var lon: Float?
    
    public override init() {
        super.init()
    }
    
    public init(lat: Float, lon: Float) {
        super.init()
        self.lat = lat
        self.lon = lon
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        lat <- map["lat"]
        lon <- map["lon"]
    }
    
}
