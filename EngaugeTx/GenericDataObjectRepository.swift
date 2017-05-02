//
//  GenericDataObjectRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/16/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

class GenericDataObjectRepository<T: ETXGenericDataObject> : Repository<T> {
    
    var genricModelResourcePath: String
    
    init(className: String) {
        self.genricModelResourcePath = "/data/class/\(className)"
        super.init(resourcePath: self.genricModelResourcePath)
    }
    
}
