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

class TrendServiceTests: XCTestCase {
    
    func testExtendingAnAggregateableModel() {
        XCTAssertEqual("indoorAirQuality", MyCustomIndoorAirQuality.resultKey, "The result key should match the parent model")
    }
    
    func testGetIndoorAggregatedData() {
        ETXTrendService.getTrend(trendTimeframe: .TwoWeeks, forClasses: [ETXIndoorAirQuality.self]) {
            (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
            
            XCTAssertNil(err, "Should not result in an error")
            XCTAssertNotNil(trendResultSet, "The trend request should return results")
            
            let indoorAirQualityTrendResult: ETXClassTrendResultSet? = trendResultSet?.getTrendForClass(ETXIndoorAirQuality.self)
            XCTAssertNotNil(indoorAirQualityTrendResult, "Indoor air quality should be a part of the trend result set")
            
            if let indoorAirQualityTrendResult = indoorAirQualityTrendResult {
                XCTAssertFalse((indoorAirQualityTrendResult.values?.isEmpty)!)
                indoorAirQualityTrendResult.values?.forEach({
                    (aggregatedData: ETXAggregatableModel) in
                    print("Average indoor air quality for \(aggregatedData.date) is \(aggregatedData.value)")
                })
                indoorAirQualityTrendResult.timeframe?.average
                XCTAssertNotNil(indoorAirQualityTrendResult.timeframe, "Should have a timeframe attribute")
            }
            
        }
    }
    
}
