//
//  CustomFunctionTests.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import XCTest
@testable import EngaugeTx

class CustomFunctionTests: ETXTestCase {
    let accessToken = "axs-tkn"
    
    override func setUp() {
        super.setUp()
        let repo = Repository<ETXModel>(resourcePath: "/")
        repo.setAccessToken(accessToken)
    }
    
    func testGetUrl() {
        let customFunctionName = "report-download"
        let cf = (CustomFunction(functionName: customFunctionName))!
        
        let urlString: String = "\(EngaugeTxApplication.baseUrl!)/run/\(customFunctionName)"
            + "?accessToken=\(accessToken)"
            + "&appId=\(EngaugeTxApplication.appId!)"
            + "&clientKey=\(EngaugeTxApplication.clientKey!)"
        
        let url = URL(string: urlString)
        XCTAssertEqual(url!, cf.getUrl()!)
    }
    
    func testPerformGet() {
        let cf = CustomFunction(functionName: "reports")
        
        cf?.performGet(queryStrings: ["babyId":"240"]) {
            (model, err) in
            
        }
    }
    
    func testIsValidFunctionNameWhenTheFunctionNameIsValid() {
        XCTAssertTrue(CustomFunction.isValidFunctionName("func-name", urlPrefix: "/run/"))
        XCTAssertTrue(CustomFunction.isValidFunctionName("funcname", urlPrefix: "/run/"))
        XCTAssertTrue(CustomFunction.isValidFunctionName("func/name", urlPrefix: "/run/"))
    }
    
    func testIsValidFunctionNameWhenTheFunctionNameIsNotValid() {
        XCTAssertFalse(CustomFunction.isValidFunctionName("func\name", urlPrefix: "/run/"))
        XCTAssertFalse(CustomFunction.isValidFunctionName("func name", urlPrefix: "/run/"))
    }
}
