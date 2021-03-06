//
//  GenericDataObjectTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/14/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx
import ObjectMapper

class GenericDataObjectTests: XCTestCase {
    
    class UserProfile : ETXGenericDataObject {
        var fullName: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            fullName <- map["fullName"]
        }
    }
    
    func testMappingToAJsonObject() {
        let profileId = "123f"
        let fullName = "Test User"
        let className = "UserProfile"
        
        let profile = UserProfile()
        profile.id = profileId
        profile.fullName = fullName
        
        let personAsString = profile.toJSONString()!
        
        // toJSONString sometimes returns properties in random order, and therefore may cause string comparison errors.
        XCTAssertTrue(personAsString.contains("\"id\":\"\(profileId)\""), "Serialized object should include profile id")
        XCTAssertTrue(personAsString.contains("\"className\":\"\(className)\""), "Serialized object should include className")
        XCTAssertTrue(personAsString.contains("\"fullName\":\"\(fullName)\""), "Serialized object should include fullName")
    }
    
    func testMappingFromAJsonObject() {
        let profileId = "123f"
        let fullName = "Test User"
        
        let jsonString: String = "{\"id\":\"\(profileId)\",\"fullName\":\"\(fullName)\"}"
        
        let expectedProfile = UserProfile()
        expectedProfile.id = profileId
        expectedProfile.fullName = fullName
        
        let actualProfile = Mapper<UserProfile>().map(JSONString: jsonString)
        
        XCTAssertEqual(expectedProfile.fullName, actualProfile?.fullName)
    }
    
}
