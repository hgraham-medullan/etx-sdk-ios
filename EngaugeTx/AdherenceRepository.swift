//
//  AdherenceRepository.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/21/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

class ETXAdherenceRepository: Repository<ETXModel> {
    
    internal let repositoryResourcePath = "/med/adherence"
    
    init() {
        super.init(resourcePath: repositoryResourcePath)
        
        self.configureTransformer(repositoryResourcePath) {
            Mapper<ETXResponse>().map(JSON: $0.content)
        }
        
    }
    
    func getMedicationAdherence(medicationId: String, startDate: Date, endDate: Date, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        let medicationIds: [String] = [medicationId]
        getMedicationAdherence(medicationIds: medicationIds, startDate: startDate, endDate: endDate, completion: completion)
    }
    
    private func getMedicationAdherence(medicationIds: [String], startDate: Date, endDate: Date, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
       
        let resource = self.etxResource
            .withParam("med", ETXStringUtils.join(strings: medicationIds, delimiter: ETXStringUtils.COMMA))
            .withParam("startDate", startDate.toTxDateFormat())
            .withParam("endDate", endDate.toTxDateFormat())
            .withParam("timezone", DateService.getCurrentTimeZoneName())
   
        let req = resource.request(.get)
        
        req.onFailure { (err) in
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            completion(nil, etxError)
        }
        
        req.onSuccess { (obj) in
            let res: ETXResponse = (obj.content as! ETXResponse)
            let results: [ETXAdherenceResultSet] = Mapper<ETXAdherenceResultSet>().mapArray(JSONArray: res.result as! [[String : Any]])!
            
            completion(results, nil)
            
        }
    }
}
