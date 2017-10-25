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
    
    public required init() {
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
    
    public override func getDataSvc<M: ETXPrescription, T: QueryablePersistenceService>(_ forModel: M) -> T {
        let repo = Repository<M>(resourcePath: "/med/data/prescriptions")
        let defaultDataSvc = ETXDataService<M>(repository: repo)
        return defaultDataSvc as! T
    }
}
