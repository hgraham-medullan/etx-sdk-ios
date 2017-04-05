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
open class ETXSpirometry: ETXMeasurement, FirstClassModel {
    
    /**
     * Forced expiratory volume in one second (FEV1)
     */
    public var fev1: Float?
    
    /**
     Unit for FEV1
     */
    public var fev1Unit: String?
    
    /**
     * 	FEV1/FVC
     */
    public var ffRatio: Float?
    
    /**
     * Peak Flow
     */
    public var peakFlow:Float?
    
    /**
     Unit for peakFlow
     */
    public var peakFlowUnit: String?
    
    /**
     * Forced Expiratory Flow at 25–75% of Forced Vital Capacity (FVC)
     */
    public var fef2575: Float?
    
    /**
     Unit for fef2575
     */
    public var fef2575Unit:String?
    
    /**
     * Forced Vital Capacity (FVC)
     */
    public var fvc: Float?
    
    /**
     Unit for FVC
     */
    public var fvcUnit: String?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        fev1 <- map["fev1"]
        fev1Unit <- map["fev1Unit"]
        ffRatio <- map["ffRatio"]
        peakFlow <- map["peakFlow"]
        peakFlowUnit <- map["peakFlowUnit"]
        fef2575 <- map["fef2575"]
        fef2575Unit <- map["fef2575Unit"]
        fvc <- map["fvc"]
        fvcUnit <- map["fvcUnit"]
    }
}
