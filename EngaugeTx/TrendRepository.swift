//
//  TrendRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
//import Siesta
import ObjectMapper
open class TrendRepository: Repository<ETXPersistedModel> {
    
    private var keyToTypeMapping: [String: ETXAggregatableModel.Type]
    
    static var trendsUrl: String {
        return "/trends"
    }
    
    public required convenience init() {
        let TRENDS_URL = "/trends"
        self.init(resourcePath: TRENDS_URL)
    }
    
    required public init(resourcePath: String) {
        self.keyToTypeMapping = [String: ETXAggregatableModel.Type]()
        super.init(resourcePath: resourcePath)
        
        self.keyToTypeMapping[ETXSteps.resultKey] = ETXSteps.self
        self.keyToTypeMapping[ETXIndoorAirQuality.resultKey] = ETXIndoorAirQuality.self
        self.keyToTypeMapping[ETXOutdoorAirQuality.resultKey] = ETXOutdoorAirQuality.self
        self.keyToTypeMapping[ETXSpirometry.resultKey] = ETXSpirometry.self
        self.keyToTypeMapping[ETXOutdoorHumidity.resultKey] = ETXOutdoorHumidity.self
        self.keyToTypeMapping[ETXOxygenSaturation.resultKey] = ETXOxygenSaturation.self
        
        self.configureTransformer(resourcePath) {
            Mapper<ETXResponse>().map(JSON: $0.content)
        }

    }
    
    public func getTrends(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], gdoConfig: ETXGenericDataObjectConfiguration?, forUser: ETXUser?, completion: @escaping (ETXTrendResultSet?, ETXError?) ->Void) {
        var classesAsString: String = ""
        classes.forEach {
            (t) in
            if classesAsString.characters.count > 0 {
                classesAsString.append(",")
            }
            classesAsString.append(t.resultKey)
        }
        
        var trendsResource = self.etxResource
            .withParam("class", classesAsString)
            .withParam("startDate", startDate.toTxDateFormat(convertToUTC: false))
            .withParam("endDate", endDate.toTxDateFormat(convertToUTC: false))
            .withParam("timezone", DateService.getCurrentTimeZoneName())
        
        if let gdoConfig = gdoConfig {
            trendsResource = trendsResource
                .withParam("dateField", gdoConfig.dateField)
                .withParam("trendField", gdoConfig.trendField)
                .withParam("trend", gdoConfig.trend?.rawValue)
        }
        
        if let forUser = forUser {
            let a = ETXSearchFilter(condition: ETXWhereCondition(property: "ownerId", comparator: ETXComparator.eq, value: forUser.id!)).toJsonString()
            trendsResource = trendsResource.withParam("shared", "true")
                .withParam("shared", "true")
                .withParam("filter", a)
        }
        
        beforeResourceRequest(trendsResource) {
            
            let req = trendsResource.request(.get)
            
            req.onFailure { (err) in
                let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
                completion(nil, etxError)
            }
            
            req.onSuccess { (obj) in
                
                let res: ETXResponse = (obj.content as! ETXResponse)
                let results: [ETXClassTrendResultSet] = Mapper<ETXClassTrendResultSet>().mapArray(JSONArray: res.result as! [[String : Any]])
                
                let trendResultSet: ETXTrendResultSet = ETXTrendResultSet()
                
                for result in results {
                    trendResultSet.classTrends[result.className!] = result
                }
                
                completion(trendResultSet, nil)
                
            }
        }
    }
}
