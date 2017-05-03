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
    private let type: ETXAggregatableModel.Type
    init(type: ETXAggregatableModel.Type) {
        self.resourceUrl = type.resourcePath
        self.type = type
        super.init(resourcePath: self.resourceUrl)
        
    }

}
