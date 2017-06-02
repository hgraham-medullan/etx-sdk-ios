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
    
    func getMedicationAdherence(medicationId: String?, startDate: Date, endDate: Date, forUser: ETXUser?, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
        
        var  medicationIds: [String]? = nil
        if let medicationId = medicationId {
             medicationIds = [medicationId]
        }
        getMedicationAdherence(medicationIds: medicationIds, startDate: startDate, endDate: endDate, forUser: forUser, completion: completion)
    }
    
    private func getMedicationAdherence(medicationIds: [String]?, startDate: Date, endDate: Date, forUser: ETXUser?, completion: @escaping ([ETXAdherenceResultSet]?, ETXError?) ->Void) {
       
        var resource = self.etxResource
            .withParam("startDate", startDate.toTxDateFormat())
            .withParam("endDate", endDate.toTxDateFormat())
            .withParam("timezone", DateService.getCurrentTimeZoneName())
        
        if let medicationIds = medicationIds {
            resource = resource.withParam("med", ETXStringUtils.join(strings: medicationIds, delimiter: ETXStringUtils.COMMA))
        }
        
        if forUser != nil && forUser?.id != nil {
            let filterString = self.appendOwnerIdToWhereFilter(filter: ETXSearchFilter(), ownerId: (forUser?.id)!)
            resource = resource
                .withParam("shared", "true")
                .withParam("filter", filterString)
        }
   
        let req = resource.request(.get)
        
        req.onFailure { (err) in
            let etxError = Mapper<ETXError>().map(JSON: err.jsonDict)
            completion(nil, etxError)
        }
        
        req.onSuccess { (obj) in
            let res: ETXResponse = (obj.content as! ETXResponse)
            let results: [ETXAdherenceResultSet] = Mapper<ETXAdherenceResultSet>().mapArray(JSONArray: res.result as! [[String : Any]])
            
            completion(results, nil)
            
        }
    }
}
