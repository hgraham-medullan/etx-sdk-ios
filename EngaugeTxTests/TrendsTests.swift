//
//  DataAggregationServiceTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/10/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class MyCustomIndoorAirQuality: ETXIndoorAirQuality { }

class TrendServiceTests: AuthenticatedTestCase {
    
    override func setUp() {
        super.setUp()
    }

    
    func testExtendingAnAggregateableModel() {
        XCTAssertEqual("IndoorAirQuality", MyCustomIndoorAirQuality.resultKey, "The result key should match the parent model")
    }
    
    func xtestCreateOxygenSaturation() {
        let testExpectation = expectation(description: "Successful getTrend")
        let repo = ETXMeasurementRepository<ETXOxygenSaturation>(type: ETXOxygenSaturation.self)
        let oxy = ETXOxygenSaturation(spo2: 1.2,spo2Unit: "uni", bpm: 3)
        repo.save(model: oxy){
            (model, err) in
            print("\(err?.details)")
            XCTAssertNil(err, "Should not result in an error: \(err?.message)")
            XCTAssertNotNil(model, "The model should be created")
            testExpectation.fulfill()
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("testCreateOxygenSaturation expectation timeout \(err)")
        }
    }
    
    func testGetIndoorAggregatedData() {
        let testExpectation = expectation(description: "Successful getTrend")
        
        ETXTrendService.getTrend(trendTimeframe: ETXTrendTimeframe.TwoWeeks, classes: [ETXIndoorAirQuality.self]) {
            (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
            print("IndoorAirQuality etx err: \(err)")
            XCTAssertNil(err, "Should not result in an error: \(err?.message)")
            XCTAssertNotNil(trendResultSet, "The trend request should return results")
            
            let indoorAirQualityTrendResult: ETXClassTrendResultSet? = trendResultSet?.getTrendForClass(ETXIndoorAirQuality.self)
            XCTAssertNotNil(indoorAirQualityTrendResult, "Indoor air quality should be a part of the trend result set")
            
            if let indoorAirQualityTrendResult = indoorAirQualityTrendResult {
                XCTAssertFalse((indoorAirQualityTrendResult.values?.isEmpty)!)
                indoorAirQualityTrendResult.values?.forEach({
                    (aggregatedData: ETXAggregatable) in
                    print("Average indoor air quality for \(aggregatedData.date) is \(aggregatedData.value)")
                })
//                indoorAirQualityTrendResult.timeframe?.average
                XCTAssertNotNil(indoorAirQualityTrendResult.timeframe, "Should have a timeframe attribute")
            }
            testExpectation.fulfill()
            
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetIndoorAggregatedData expectation timeout \(err)")
        }
    }
    
    func testGetIndoorAggregatedDataWithExplicitStartandEndDate() {
        let testExpectation = expectation(description: "Successful getTrend")
        let endDate: Date = Date()
        let startDate = DateService.subtractTimeframe(timeframe: .TwoWeeks, date: endDate)
        ETXTrendService.getTrend(startDate: startDate, endDate: endDate, classes: [ETXIndoorAirQuality.self]) {
            (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
            
            XCTAssertNil(err, "Should not result in an error")
            XCTAssertNotNil(trendResultSet, "The trend request should return results")
            
            let indoorAirQualityTrendResult: ETXClassTrendResultSet? = trendResultSet?.getTrendForClass(ETXIndoorAirQuality.self)
            XCTAssertNotNil(indoorAirQualityTrendResult, "Indoor air quality should be a part of the trend result set")
            
            if let indoorAirQualityTrendResult = indoorAirQualityTrendResult {
                XCTAssertFalse((indoorAirQualityTrendResult.values?.isEmpty)!)
                indoorAirQualityTrendResult.values?.forEach({
                    (aggregatedData: ETXAggregatable) in
                    print("Average indoor air quality for \(aggregatedData.date) is \(aggregatedData.value)")
                })
//                indoorAirQualityTrendResult.timeframe?.average
                XCTAssertNotNil(indoorAirQualityTrendResult.timeframe, "Should have a timeframe attribute")
            }
            testExpectation.fulfill()
            
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetIndoorAggregatedDataWithExplicitStartandEndDate expectation timeout \(err)")
        }
    }
    
    func testGetMultipleAggregatedData() {
        let testExpectation = expectation(description: "Successful getTrend")
        let classes = [ETXIndoorAirQuality.self, ETXSteps.self, ETXOutdoorAirQuality.self, ETXSpirometry.self,ETXOxygenSaturation.self] as [Any]
        ETXTrendService.getTrend(trendTimeframe: ETXTrendTimeframe.TwoWeeks, classes: classes as! [ETXAggregatableModel.Type]) {
            (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
            XCTAssertNil(err, "Should not result in an error: \(err?.message)")
            XCTAssertNotNil(trendResultSet, "The trend request should return results")
            
            for clazz in classes {
                let classType = clazz as! ETXAggregatableModel.Type
                let resultKey = classType.resultKey
                let classTypeTrendResult: ETXClassTrendResultSet? = trendResultSet?.getTrendForClass(classType)
                XCTAssertNotNil(classTypeTrendResult, "\(resultKey) should be a part of the trend result set")
                
                if let trendResult = classTypeTrendResult {
                    XCTAssertFalse((trendResult.values?.isEmpty)!)
                    trendResult.values?.forEach({
                        (aggregatedData: ETXAggregatable) in
                        print("\(resultKey) aggregatedData.Date: \(aggregatedData.date) | aggregatedData.value: \(aggregatedData.value)")
                    })
                    XCTAssertNotNil(trendResult.timeframe, "Should have a timeframe attribute")
                }
            }

            testExpectation.fulfill()
            
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetMultipleAggregatedData expectation timeout \(err)")
        }
    }
    
    class GenericObjectWithCustomModelName: ETXGenericDataObject {
        override class var customModelName: String? {
            return "Breathing"
        }
        override class var trendResultKey: String {
            return "custom.Breathing"
        }
    }
    
    func testGetTrendAggregatedDataForGDO() {
        let testExpectation = expectation(description: "Successful getTrend")
        let dateFieldPropertyName = "date";
        let valueFieldPropertyName = "value";
        let aggregrationToApply = ETXTrendAggregation.avg
        let gdoConfigForTrends: ETXGenericDataObjectConfiguration = ETXGenericDataObjectConfiguration(
            dateField: dateFieldPropertyName,
            trendField: valueFieldPropertyName,
            trend: aggregrationToApply
        )
        ETXTrendService.getTrend(trendTimeframe: ETXTrendTimeframe.TwoWeeks, classes: [GenericObjectWithCustomModelName.self], gdoConfig: gdoConfigForTrends) {
            (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
            XCTAssertNil(err, "Should not result in an error: \(err?.message)")
            XCTAssertNotNil(trendResultSet, "The trend request should return results")
            
            let trendResultSet: ETXClassTrendResultSet? = trendResultSet?.getClassSummary(GenericObjectWithCustomModelName.self)
            XCTAssertNotNil(trendResultSet, "Indoor air quality should be a part of the trend result set")
            
            if let trendResult = trendResultSet {
                XCTAssertFalse((trendResult.values?.isEmpty)!)
                trendResult.values?.forEach({
                    (aggregatedData: ETXAggregatable) in
                    print("Data for GDO: \(aggregatedData.date) is \(aggregatedData.value)")
                })
                XCTAssertNotNil(trendResult.timeframe, "Should have a timeframe attribute")
            }
            testExpectation.fulfill()
            
        }
        waitForExpectations(timeout: 20) {
            (err) in
            print("testGetTrendAggregatedDataForGDO expectation timeout \(err)")
        }
    }
    
}
