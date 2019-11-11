//
//  CustomTrendsRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/23/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

open class CustomTrendRepository: TrendRepository, CustomizableRepository {

    public var httpPath: String!
    
    required public init(resourcePath: String) {
        super.init(resourcePath: resourcePath)
    }
    
    override open func getTrends(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration?, forUser: ETXUser?, completion: @escaping (ETXTrendResultSet?, ETXError?) -> Void) {
        super.getTrends(startDate: startDate, endDate: endDate, classes: classes, gdoConfig: gdoConfig, forUser: forUser, completion: completion)
        self.getAggregatedData(startDate: startDate, endDate: endDate, classes: classes, gdoConfig: gdoConfig, forUser: forUser, completion: completion)
    }
    
    

    open func getAggregatedData(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration?, forUser: ETXUser?, completion: @escaping (ETXTrendResultSet?, ETXError?) -> Void) {
        //self.getTrends(startDate: startDate, endDate: endDate, classes: classes, gdoConfig: gdoConfig, forUser: forUser, completion: completion)
    }
    
    public override func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
    }
    
    open func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXModel {
        return nil
    }
}
