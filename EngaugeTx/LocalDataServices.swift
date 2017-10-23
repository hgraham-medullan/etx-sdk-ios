//
//  LocalDataServices.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/17/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

open class LocalDataService<T:ETXPersistedModel> : ETXDataService<T> {
    
    public convenience  init(modelName: String) {
        self.init(repository: LocalDataRepository(resourcePath: modelName))
    }
    
    public required convenience override init() {
        self.init(repository: LocalDataRepository<T>(resourcePath: String(describing: T.self)))
    }
    
    required public init(repository: Repository<T>) {
        super.init(repository: repository)
    }
}

open class LocalDataRepository<T: ETXPersistedModel> : Repository<T> {
    override public func findWhere(_ filter: ETXSearchFilter, completion: @escaping ([T]?, ETXError?) -> Void) {
        //
        completion(self.localStore, nil)
    }
    public override func delete(model: T, completion: @escaping (ETXError?) -> Void) {
        // Code
        completion(nil)
    }
    
    public override func getById(_ id: String, completion: @escaping (T?, ETXError?) -> Void) {
        // Code
        completion(self.localStore.first, nil)
    }
    
    private var localStore: [T]
    
    required public init(resourcePath: String) {
        self.localStore = [T]()
//        let item1: T =  ETXGenericDataObject() as! T
//        item1.id = "item-1"
//        self.localStore.append(item1)
        super.init(resourcePath: resourcePath)
    }
}
