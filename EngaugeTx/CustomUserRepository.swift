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
    
    var httpPath: String!
    
    public override func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
        // Do not call completion func
        
    }
    
}
