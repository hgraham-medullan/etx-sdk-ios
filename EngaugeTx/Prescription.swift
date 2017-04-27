//
//  Prescription.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXPrescription: ETXShareableModel{
    public var description: String?
    public var effectivePeriod: ETXEffectivePeriod?
    public var device: ETXMeasurementDevice?
    public var route: String?
    public var dosage: [ETXPrescriptionDosage]?
    public var medication: ETXMedication?
    public var medicationId: String?
    
    public override init() {
        super.init()
    }
    
    override class var modelResourcePath: String {
        return "/med/data/prescriptions"
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        description <- map["description"]
        effectivePeriod <- map["effectivePeriod"]
        device <- map["device"]
        route <- map["route"]
        dosage <- map["dosage"]
        medication <- map["medication"]
        medicationId <- map["medicationId"]
    }
    
    open override class func getDataSvc<ETXPrescription>() -> ETXDataService<ETXPrescription>? {
        
        return ETXDataService<ETXPrescription>(repository: Repository<ETXPrescription>(resourcePath: "/med/data/prescriptions"))
    }
}
