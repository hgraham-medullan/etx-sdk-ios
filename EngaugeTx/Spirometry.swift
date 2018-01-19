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
    
    override open class var trendResultKey: String {
        return "Spirometry"
    }
    override class var modelResourcePath: String {
        return "/Spirometry"
    }
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        fev1 <- map["fev1"]
        peakFlow <- map["peakFlow"]
        fef2575 <- map["fef2575"]
        fvc <- map["fvc"]
        
        fev1Unit <- map["fev1Unit"]
        peakFlowUnit <- map["peakFlowUnit"]
        fef2575Unit <- map["fef2575Unit"]
        fvcUnit <- map["fvcUnit"]
        
        ffRatio <- map["ffRatio"]
    }
    
    public override func getDataSvc<M: ETXSpirometry, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let repository = ETXShareableModelRespository<M>(resourcePath: "/Spirometry")
        let defaultDataSvc = ETXShareableModelDataService<M>(repository: repository)
        return defaultDataSvc as! T
    }
    
}
