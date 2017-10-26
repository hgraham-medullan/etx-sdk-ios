//
//  CustomUserRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/22/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
open class ETXCustomUserRepository<M: ETXUser>: UserRepository<M>, CustomizableRepository {
    
    public var httpPath: String!
    
    public func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXModel {
        return nil
    }
    
    required public init(resourcePath: String) {
        super.init(resourcePath: resourcePath)
    }
    
    public override func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
        // Do not call completion func
        
    }
    
}
