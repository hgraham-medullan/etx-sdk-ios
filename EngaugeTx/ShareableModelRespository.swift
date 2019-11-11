//
//  ShareableModelRespository.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

open class ETXShareableModelRespository<T: ETXShareableModel>: Repository<T> {
    
    private let resourceUrl: String
    
    private let QUERY_PARAM_SHARED: String = "shared"
    private let QUERY_PARAM_FILTER: String = "filter"
    private let QUERY_PARAM_VALUE_SHARED: String = "true"
    private let FILTER_FIELD_NAME_OWNER_ID: String = "ownerId"
    
    required public init(resourcePath: String) {
        self.resourceUrl = resourcePath
        super.init(resourcePath: self.resourceUrl)
    }
    
    private func getOwnerFilter(_ ownerId: String) -> String {
        let condition = ETXWhereCondition(property: FILTER_FIELD_NAME_OWNER_ID, comparator: .eq, value: ownerId)
        return ETXSearchFilter(condition: condition).toJsonString()
    }
    
    open func findById(_ id: String, onBehalfOfUser: ETXUser, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        if (id.isEmpty) {
            let message = "A value for 'id' is required"
            completion(nil, ETXError(message:message))
        } else {
            let resource: Resource = self.etxResource.child(id)
                .withParam(QUERY_PARAM_SHARED, QUERY_PARAM_VALUE_SHARED)
                .withParam(QUERY_PARAM_FILTER, self.getOwnerFilter(onBehalfOfUser.id!))
            self.performFindById(resource, completion)
        }
    }
    
    open func findWhere(_ filter: ETXSearchFilter, onBehalfOfUser: ETXUser, completion: @escaping (_ model: [T]?, _ err: ETXError?) -> Void) {
        let resource: Resource = self.getResourceUri(filter, ownerId: onBehalfOfUser.id!)
            .withParam(QUERY_PARAM_SHARED, QUERY_PARAM_VALUE_SHARED)
        self.performFindWhere(resource, completion)
        
    }
    
    func isOwnedByCurrentUser(_ model: ETXShareableModel) -> Bool{
        if(model.ownerId != nil && self.getCurrentUserId() != model.ownerId){
            return false
        }
        return true
    }
    
    func getResourceUri(_ filter: ETXSearchFilter, ownerId: String) -> Resource{
        let updatedFilter = self.appendOwnerIdToWhereFilter(filter: filter, ownerId: ownerId)
        return self.etxResource.withParam(QUERY_PARAM_FILTER, updatedFilter)
    }
    
    public override func makeRequest(resource: Resource,
                                     httpMethod: RequestMethod,
                                     model: T?,
                                     errorListener: @escaping (RequestError) -> Void,
                                     successListener: @escaping (Entity<Any>) -> Void){
        
        var resourceWithParamas = resource
        
        if (model != nil ){
            let shareableModel: ETXShareableModel = model!
            if (shareableModel.ownerId != nil && !self.isOwnedByCurrentUser(shareableModel) ) {
                resourceWithParamas = resource.withParam(QUERY_PARAM_SHARED, QUERY_PARAM_VALUE_SHARED)
                    .withParam(QUERY_PARAM_FILTER, self.getOwnerFilter(shareableModel.ownerId!))
            }
        }
        super.makeRequest(resource: resourceWithParamas,
                          httpMethod: httpMethod,
                          model: model,
                          errorListener: errorListener,
                          successListener: successListener)
    }
    
    
}
