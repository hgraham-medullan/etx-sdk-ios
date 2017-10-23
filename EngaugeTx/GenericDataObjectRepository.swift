//
//  GenericDataObjectRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/16/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

open class ETXGenericDataObjectRepository<T: ETXGenericDataObject> : Repository<T> {
    typealias GenericDataObjectRepository = ETXGenericDataObjectRepository<T>
    
    var genericModelResourcePath: String
    
    convenience init(className: String) {
        let genericModelResourcePath = "/data/class/\(className)"
        self.init(resourcePath: genericModelResourcePath)
    }
    
    required public init(resourcePath: String) {
        self.genericModelResourcePath = resourcePath
        super.init(resourcePath: resourcePath)
    }
    
}


