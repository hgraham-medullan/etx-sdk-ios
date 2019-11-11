//
//  StandaloneFunctionDataService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/23/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

open class StandaloneFunctionDataService<T: ETXModel> {
    private let urlPrefix = "/run"
    var repository: Repository<T>
    private var functionName: String
    
    public init(functionName: String) {
        self.functionName = functionName
        self.repository = Repository<T>(resourcePath: "\(urlPrefix)/\(functionName)")
    }
    
    private func getRepository() -> Repository<T> {
        return self.repository
    }
}
