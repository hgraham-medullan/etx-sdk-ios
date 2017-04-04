//
//  Coords.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 4/4/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

public class ETXCoords : Mappable {
    
    var rawJson: [String:Any]?
    var longitude: Float
    var latitude: Float
    
    public init(lat: Float, lon: Float) {
        self.latitude = lat
        self.longitude = lon
    }
    
    required public init?(map: Map) {
        self.longitude = 0
        self.latitude = 0
        self.rawJson = map.JSON
    }
    
    open func mapping(map: Map) {
        longitude <- map["lon"]
        latitude <- map["lat"]
    }
}
