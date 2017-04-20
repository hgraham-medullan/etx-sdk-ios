//
//  ShareableModelRespository.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

public class ETXShareableModelRespository<T: ETXShareableModel>: Repository<T> {
    
    private let resourceUrl: String
    private let type: ETXAggregatableModel.Type
    
    private let QUERY_PARAM_SHARED: String = "shared"
    private let QUERY_PARAM_VALUE_SHARED: String = "true"
    
    init(type: ETXAggregatableModel.Type) {
        self.resourceUrl = type.resourcePath
        self.type = type
        super.init(resourcePath: self.resourceUrl)
//        ETXInternalService.getCurrentUserId()
        
        
    }
    
    
    
}
