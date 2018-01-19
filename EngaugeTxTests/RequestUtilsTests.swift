//
//  RequestUtilsTests.swift
//  EngaugeTxTests
//
//  Created by Layton Whiteley on 1/18/18.
//  Copyright © 2018 Medullan Platform Solutions. All rights reserved.
//

import XCTest
@testable import EngaugeTx

class RequestUtilsTests: XCTestCase {
    
    func testjsonStringToDictionary() {
        let expectedJsonString: String = "ssample=sdsdd&filter={\"where\":{\"age\":{\"gt\":20}, \"ownerId\":\"878\"}}"
        let querydict = ETXRequestUtils.queryToDictionary(query: expectedJsonString)
        let testDict = ETXRequestUtils.jsonStringToDictionary(json: querydict["filter"] as! String);
        var test2 = testDict!["where"] as? [String: Any];
        test2!["ownerId"] = "sampleid"
        
        let convertedString = ETXRequestUtils.convertJSONDataToString(test2)
        
    }
    
    func testShouldConvertQueryStringToDict(){
        let queryString: String = "ssample=sdsdd&filter={\"where\":{\"age\":{\"gt\":20}, \"ownerId\":\"878\"}}"
        let querydict = ETXRequestUtils.queryToDictionary(query: queryString)
        XCTAssertEqual(querydict["ssample"], "sdsdd")
        XCTAssertEqual(querydict["filter"], "{\"where\":{\"age\":{\"gt\":20}, \"ownerId\":\"878\"}}")
        
    }
    
    func testShouldConvertJSONStringToDict(){
        let jsonString: String = "{\"where\":{\"age\":{\"gt\":20}, \"ownerId\":\"878\"}}"
        let result = ETXRequestUtils.jsonStringToDictionary(json: jsonString);
        
        let whereCond = result!["where"] as? [String: Any];
        let ageCond = whereCond!["age"] as? [String: Any];
        let gtCond: Int? = ageCond!["gt"] as? Int
        let ownerIdCond: String? = whereCond!["ownerId"] as? String
        
        XCTAssertEqual(gtCond, 20)
        XCTAssertEqual(ownerIdCond, "878")
        
    }
    
    func testShouldConvertJSONDataToString(){
        let jsonString: String = "{\"where\":{\"age\":{\"gt\":20},\"ownerId\":\"878\"}}"
        var result = ETXRequestUtils.jsonStringToDictionary(json: jsonString);
        
        var whereCond = result!["where"] as? [String: Any];
        whereCond!["ownerId"] = "testout"
        result!["where"] = whereCond
        
        let convertedString = ETXRequestUtils.convertJSONDataToString(result)
        let expectedString: String = "{\"where\":{\"age\":{\"gt\":20},\"ownerId\":\"testout\"}}"
        
        XCTAssertEqual(convertedString, expectedString)
        
    }
    
    
    
    func testShouldReturnJoinedyStringWhenArrayisNotEmptyAndCustomDelimiterPassed(){
        let strings: [String]? = ["testing", "123"]
        let result = ETXStringUtils.join(strings: strings!, delimiter: ETXStringUtils.COMMA)
        XCTAssertEqual(result, "testing,123")
        
    }
    
    
}
