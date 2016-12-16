//
//  GenericDataServiceTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/15/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class GenericDataServiceTests: XCTestCase {
    
    class Vitals: ETXGenericDataObject { }
    
    func testExtendedGenericDataServiceWhenNotInitializedWithClassName() {
        
        class VitalsService: GenericDataService<Vitals> { }
        
        let expectedClassName = "Vitals"
        let vitalsService = VitalsService()
        XCTAssertEqual(expectedClassName, vitalsService.modelName)
    }
    
    func testExtendedGenericDataServiceWhenInitializedWithClassName() {
        let className = "VitalMeasurements"
        class VitalMeasurementsService: GenericDataService<Vitals> {
            init() { super.init(modelName: "VitalMeasurements") }
        }
        
        let vitalMeasurementsService = VitalMeasurementsService()
        XCTAssertEqual(className, vitalMeasurementsService.modelName)
    }
    
}
