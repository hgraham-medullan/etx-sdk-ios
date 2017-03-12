//
//  TrendRepositoryTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class TrendRepositoryTests: XCTestCase {
    
    func xtestRep() {
        let trendRepo = TrendRepository()
        trendRepo.getTrends(startDate: Date(), endDate: Date(), classes: [ETXSteps.self]) {
            (_, _) in
        }
        XCTAssertEqual("", trendRepo.etxResource.url.absoluteString)
        
    }
    
    func xtestTime() {
        
        let z = Double(TimeZone.current.secondsFromGMT()+30*60)/(60*60)
        print(z)
    }
    
}
