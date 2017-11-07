//
//  CustomStandaloneFunctionRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/23/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

open class ETXCustomStandaloneFunctionRepository<M: ETXModel>: Repository<M>, CustomizableRepository {
    public var httpPath: String!
    
    public func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXModel {
        return nil
    }
    required public init(resourcePath: String) {
        super.init(resourcePath: resourcePath)
    }
    
    public override func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
    }
    
    override open func create(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        self.post(model: model, completion: completion)
    }
    
    override func save(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        self.post(model: model, completion: completion)
    }
    
    open override func getById(_ id: String, completion: @escaping (M?, ETXError?) -> Void) {
        self.get(completion:completion)
    }
    
    open func get(completion: @escaping (M?, ETXError?) -> Void) {
        super.getById("", completion: completion)
    }
    
    open func post(model: M, completion: @escaping (M?, ETXError?) -> Void) {
        super.create(model: model, completion: completion)
    }
}
