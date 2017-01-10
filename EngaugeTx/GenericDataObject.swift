//
//  GenericDataObject.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/14/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Use Generic Data Objects to store data that is unique to your application
 
 ```
 class DoctorVisit: ETXGenericDataObject {
    var visitDate: Date?
 
    override func mapping(map: Map) {
        super.mapping(map: map)
        visitDate <- (map["visitDate"], DateTransform())
    }
 }
 
 class DoctorVisitService: ETXGenericDataService<DoctorVisit> {
    // Do some logic
 }
 
 let doctorVisitSvc = DoctorVisitService()
 doctorVisitSvc.findAll {
    (doctorVisits, err) in
    guard let doctorVisits = doctorVisits else {
        // do err handling
        return
    }
 
    print(doctorVisits)
 }
 
 ```
 
 */



open class ETXGenericDataObject: ETXModel {
    
    open class var modelName: String {
        return String(describing: self)
    }
    
    private static func getModelName() -> String {
        print(self.modelName)
        print(modelName)
        return modelName
    }
    
    private static var dataSvc: ETXGenericDataService<ETXGenericDataObject> {
        return try! ETXGenericDataService<ETXGenericDataObject>(modelName: getModelName())
    }
    
    override init() {
        super.init()
    }
    
    /**
     Create an instance from a Map
     - parameter map: The Map object
     */
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    /**
     Describes how the object should be desearialized
     - parameter map: The data as a Map
     */
    override open func mapping(map: Map) {
        super.mapping(map: map)
    }
    
    public func save(completion: @escaping (ETXError?) -> Void) {
        ETXGenericDataObject.dataSvc.save(model: self) {
            (model, err) in
            if let model = model {
                let map = Map(mappingType: .fromJSON, JSON: model.rawJson!)
                self.mapping(map: map)
            }
            completion(err)
        }
    }
    
    public func delete(completion: @escaping (ETXError?) -> Void) {
        ETXGenericDataObject.dataSvc.delete(model: self) {
            (err) in
            if err == nil {
                self.id = nil
            }
            completion(err)
        }
    }
    
    public class func findById(_ id: String, completion: @escaping (ETXGenericDataObject?, ETXError?)->Void) {
        ETXGenericDataObject.dataSvc.findById(id, completion: completion)
    }
    
    public class func findByWhere(filter: String, completion: @escaping ([ETXGenericDataObject]?, ETXError?)->Void) {
        ETXGenericDataObject.dataSvc.findWhere(filter, completion: completion)
    }
    
}
