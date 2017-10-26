//
//  MeasurementRepository.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

public class ETXMeasurementRepository<T: ETXMeasurement>: Repository<T> {
    
    private let resourceUrl: String
    private var type: ETXAggregatableModel.Type
    convenience init(type: ETXAggregatableModel.Type) {
        let resourceUrl: String  = type.resourcePath
        self.init(resourcePath: resourceUrl)
        self.type = type
    }
    
    required public init(resourcePath: String) {
        self.resourceUrl = resourcePath
        self.type = ETXMeasurement.self
        super.init(resourcePath: resourcePath)
        
    }

}
