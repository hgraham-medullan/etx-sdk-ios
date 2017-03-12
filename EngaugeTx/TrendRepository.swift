//
//  TrendRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 3/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta
import ObjectMapper
class TrendRepository: Repository<ETXModel> {
    
    let SAMPLE_JSON: String = "{\"results\":[{\"indoorAirQuality\":{\"values\":[{\"value\":1,\"count\":1,\"date\":\"2017-03-10\"},{\"value\":4,\"count\":2,\"date\":\"2017-03-09\"},{\"value\":1.5,\"count\":2,\"date\":\"2017-03-08\"}],\"timeframe\":{\"count\":5,\"sum\":12,\"avg\":2.4,\"lastValue\":1,\"lastDate\":\"2017-03-10T19:25:16.042Z\"},\"meta\":{\"groupBy\":\"dateLogged\",\"field\":\"fev1\",\"agg\":\"sum\"}}},{\"steps\":{\"values\":[{\"value\":9834,\"date\":\"2017-02-28\"}],\"...\":\"...\"}},{\"spirometry\":{\"values\":[{\"value\":0.6,\"date\":\"2017-02-28\"}],\"timeframe\":{\"startDate\":\"2017-02-01T00:00:00.00Z\",\"endDate\":\"2017-02-28T23:59:59.999Z\",\"average\":0.6,\"sum\":0.6,\"count\":1,\"lastValue\":0.6,\"lastDate\":\"2017-02-28T14:09:05.00Z\"}}}],\"meta\":{}}"
    
    private let TRENDS_URL = "/trends"
    
    private var keyToTypeMapping: [String: ETXAggregatableModel.Type]
    
    init() {
        self.keyToTypeMapping = [String: ETXAggregatableModel.Type]()
        super.init(resourcePath: TRENDS_URL)
        
        self.keyToTypeMapping[ETXSteps.resultKey] = ETXSteps.self
        self.keyToTypeMapping[ETXIndoorAirQuality.resultKey] = ETXIndoorAirQuality.self
        self.keyToTypeMapping[ETXOutdoorAirQuality.resultKey] = ETXOutdoorAirQuality.self
        self.keyToTypeMapping[ETXSpirometry.resultKey] = ETXSpirometry.self
        self.keyToTypeMapping[ETXOutdoorHumidity.resultKey] = ETXOutdoorHumidity.self
    }
    
    func getTrends(startDate: Date, endDate: Date, classes: [ETXAggregatableModel.Type], completion: @escaping (ETXTrendResultSet?, ETXError?) ->Void) {
        var classesAsString: String = ""
        classes.forEach {
            (t) in
            if classesAsString.characters.count > 0 {
                classesAsString.append(",")
            }
            classesAsString.append(t.resultKey)
        }
        
        let trendsResource = self.etxResource
            .withParam("classes", classesAsString)
            .withParam("startDate", startDate.toTxDateFormat())
            .withParam("endDate", endDate.toTxDateFormat())
            .withParam("timezoneOffset", "\(DateService.getCurrentTimeZoneOffset())")
        
        //        let req = trendsResource.request(.get)
        
        //        req.onFailure { (err) in
        //            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
        //            completion(nil, etxError)
        //        }
        
        //        req.onSuccess { (obj) in
        let m: ETXModel? = Mapper<ETXModel>().map(JSONString: self.SAMPLE_JSON)
        
        let trendResultSet: ETXTrendResultSet = ETXTrendResultSet()
        
        let results: [[String:Any]]? = m?.rawJson?["results"] as! [[String : Any]]?
        if let results = results {
            results.forEach({
                (classTrendData: [String:Any]) in
                for(className, trendData ) in classTrendData {
                    let classTrendResultSet = Mapper<ETXClassTrendResultSet>().map(JSON: trendData as! [String : Any])
                    
                    if classTrendResultSet != nil {
                        trendResultSet.classTrends[className] = classTrendResultSet
                    }
                }
            })
        }
        completion(trendResultSet, nil)
        //        }
    }
}
