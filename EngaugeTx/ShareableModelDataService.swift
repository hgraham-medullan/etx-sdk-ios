//
//  ShareableModelDataService.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/22/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

/**
 Service class for handling shareable models
 */
open class ETXShareableModelDataService<T: ETXShareableModel>: ETXDataService<T> {
    public override init() {
        super.init()
    }
    
    required public init(repository: Repository<T>) {
        super.init(repository: repository)
    }
 
    override func getRepository(_ model: T? = nil) -> ETXShareableModelRespository<T> {
        return super.getRepository(model) as! ETXShareableModelRespository<T>
    }
    
    public func findById(_ id: String, onBehalfOfUser: ETXUser, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        self.getRepository().findById(id, onBehalfOfUser: onBehalfOfUser, completion: completion)
    }
    
    public func findWhere(_ filter: ETXSearchFilter, onBehalfOfUser: ETXUser, completion: @escaping (_ model: [T]?, _ err: ETXError?) -> Void) {
        self.getRepository().findWhere(filter, onBehalfOfUser: onBehalfOfUser, completion: completion)
        
    }
}
