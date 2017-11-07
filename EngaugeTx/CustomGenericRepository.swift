//
//  CustomGenericRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/23/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

open class ETXCustomGenericObjectRepository<M:ETXGenericDataObject>: ETXGenericDataObjectRepository<M>, CustomizableRepository {
    
    public var httpPath: String!
    
    open func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXModel {
        return nil
    }
    
    required public init(resourcePath: String) {
     super.init(resourcePath: resourcePath)
    }

    /**
     Action to perform
    */
    public override func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
    }
    
}
