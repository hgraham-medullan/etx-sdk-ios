//
//  Spirometry.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 * Represents the measure of lung capacity/function
 */
open class ETXSpirometry: ETXAggregatableModel {
    
    /**
     * Forced expiratory volume in one second (FEV1)
     */
    public var fev1: Float?
    
    /**
     * 	FEV1/FVC
     */
    public var ffRatio: Float?
    
    /**
     * Peak Flow
     */
    public var peakFlow:Float?
    
    /**
     * Forced Expiratory Flow at 25–75% of Forced Vital Capacity (FVC)
     */
    public var fef2575: Float?
    
    /**
     * Forced Vital Capacity (FVC)
     */
    public var fvc: Float?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        fev1 <- map["fev1"]
        ffRatio <- map["ffRatio"]
        peakFlow <- map["peakFlow"]
        fef2575 <- map["fef2575"]
        fvc <- map["fvc"]
    }
}
