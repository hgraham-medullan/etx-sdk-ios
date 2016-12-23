//
//  GenericDataObjectRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/16/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

class GenericDataObjectRepository<T: ETXGenericDataObject> : Repository<T> {
    
    init(className: String) {
        super.init(resourcePath: "/data/class/\(className)")    
    }
    
}
