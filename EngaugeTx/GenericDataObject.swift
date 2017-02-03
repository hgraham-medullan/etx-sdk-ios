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
open class ETXGenericDataObject: ETXModel, ETXPersistentGenericObject {
    
    // 
    private var _className: String?
    private  var className: String {
        get {
            return _className ?? String(describing: (Mirror(reflecting: self)).subjectType)
        }
        set {
            // TODO: Use the custom name instead or store both
            _className = newValue
        }
    }
    
    /**
     When the name of the model needs to differ from the class name, it can be
     configured by overriding and populating this property
     */
    open class var customModelName: String? {
        return nil
    }
    
    /**
     Create an instance of GenericData Object
     */
    override public init() {
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
        className <- map["className"]
        
    }
}


/**
 Provides persistence functionalities for a generic object
 */
public protocol ETXPersistentGenericObject {
    typealias ModelType = Self
    static var customModelName: String? { get }
    static var modelName: String { get }
}

extension ETXPersistentGenericObject where Self: ETXGenericDataObject {
    
    internal func getModelName() -> String {
        var s: String
        if let customModelName = Self.customModelName {
            s = customModelName
        } else {
            s = String(describing: (Mirror(reflecting: self)).subjectType)
        }
        return s
    }
    
    /**
     The name of the model as persisted on the platform
    */
    public static var modelName: String {
        if let customModelName = Self.customModelName {
            return customModelName
        }
        return String(describing: self)
    }
    
    var dataSvc: ETXGenericDataService<ModelType> {
        return try! ETXGenericDataService<ModelType>(modelName: getModelName())
    }
    
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    public static func findById(_ id: String, completion: @escaping (ModelType?, ETXError?)->Void) {
        let dataSvc: ETXGenericDataService<ModelType> = try! ETXGenericDataService<ModelType>(modelName: modelName)
        dataSvc.findById(id, completion: completion)
    }
    
    /**
     Find all elements matching the filter condition(s)
     - parameter filter: Filter to apply to the query
     - parameter completion: Callback when the request completes
     - parameter models: Models of the specified type. Will be ```nil``` if an error occurred
     - parameter err: If an error occurred while getting all items. Will be ```nil``` if get all was successful
     */
    public static func findWhere(filter: ETXSearchFilter, completion: @escaping ([ModelType]?, ETXError?)->Void) {
        let dataSvc: ETXGenericDataService<ModelType> = try! ETXGenericDataService<ModelType>(modelName: modelName)
        dataSvc.findWhere(filter, completion: completion)
    }
    
    /**
     Save the model. Properties will be updated with new values where applicable
     - parameter completion: Callback when the request completes
     - parameter err: If an error occurred while savinga the item
     */
    public func save(completion: @escaping (ETXError?) -> Void) {
        self.dataSvc.save(model: self) {
            (model, err) in
            if let model = model {
                let map = Map(mappingType: .fromJSON, JSON: model.rawJson!)
                self.mapping(map: map)
            }
            completion(err)
        }
    }
    
    /**
     Delete the current model
     - parameter completion: Callback when the request completes
     - parameter err: If an error occurred while deleting the item
     */
    public func delete(completion: @escaping (ETXError?) -> Void) {
        self.dataSvc.delete(model: self) {
            (err) in
            if err == nil {
                self.id = nil
            }
            completion(err)
        }
    }
    
    
}
