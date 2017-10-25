//
//  CustomTrendsRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/25/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class CustomTrendsRepository: ETXTestCase {
    
    override func tearDown() {
        super.tearDown()
        EngaugeTxApplication.clearCustomRepositories()
    }
    
    func testTrends() {
        let findByIdExpectation = expectation(description: "findById Expectation")
        ETXTrendService.useCustomDataRepository(LocalTrendRepo.self)
        
        var classes = [ETXAggregatableModel.Type]()
        classes.append(ETXSteps.self)
        
        ETXTrendService.getTrend(startDate: Date(), endDate: Date(), classes: classes) {
            (res, err) in
            findByIdExpectation.fulfill()
        }
        waitForExpectations(timeout: 10) {
            (err) in
            print("findById Expectation \(String(describing: err))")
        }
        
    }
}

class LocalTrendRepo: CustomTrendRepository {
    
    override func getAggregatedData(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration?, forUser: ETXUser?, completion: @escaping (ETXTrendResultSet?, ETXError?) -> Void) {
        
        var expectedClasses = [ETXAggregatableModel.Type]()
        expectedClasses.append(ETXSteps.self)
        XCTAssertTrue(classes.count == 1)
        XCTAssertEqual(String(describing: expectedClasses.first!), String(describing: classes.first!), "The custom repo should only cater for steps")
        let reqUrl = self.getHttpPath()
        XCTAssertTrue(reqUrl.contains("/trends"))
        
        print(self.getHttpPath())
        completion(nil, nil)
    }
}
