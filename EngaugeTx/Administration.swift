//
//  Administration.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

open class ETXAdministration: ETXShareableModel{
    public var patient: ETXUser?
    public var effectiveDate: Date?
    public var device: ETXMeasurementDevice?
    public var note: String?
    public var prescriptionId: String?

    public var dosage: ETXPrescriptionDosage?
    public var prescription: ETXPrescription?
    
    public override init() {
        super.init()
    }
    
    override class var modelResourcePath: String {
        return "/med/data/administrations"
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
        note <- map["note"]
        effectiveDate <- (map["effectiveDate"], ETXDateTransform())
        device <- map["device"]
        prescriptionId <- map["prescriptionId"]
        patient <- map["patient"]
        dosage <- map["dosage"]
        prescription <- map["prescription"]
    }
}
