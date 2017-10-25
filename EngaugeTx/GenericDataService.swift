//
//  GenericDataService.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/15/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Provides the ability to manage Generic Data Objects
 
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
 
 ```repos
 
 */
open class ETXGenericDataService<T: ETXGenericDataObject>: ETXDataService<T> {
    
    var modelName: String
    
    /**
     Create an instance GenericDataService with a custom model name
     - parameter modelName: The custom name for the model. Used as part of the api URL
     */
    public required init(modelName: String) throws {
        if ETXGenericDataService.isValidClassName(modelName) == true {
            self.modelName = modelName
            super.init(repository:  ETXGenericDataObjectRepository<T>(className: modelName))
        } else {
            EngaugeTxLog.error("\(modelName) is not a valid model name for a Generic Object")
            throw ETXInvalidModelNameError()
        }
    }
    
    /**
     Create an instance GenericDataService
     */
    public override init() {
        self.modelName = String(describing: T.self)
        super.init(repository:  ETXGenericDataObjectRepository<T>(className: self.modelName))
    }
    
    
    required public init(repository: Repository<T>) {
        self.modelName = String(describing: T.self)
        let r = ETXGenericDataService.getRepository(defaultRepo: repository as! ETXGenericDataObjectRepository<T>, forModelType: T.self)
        super.init(repository: r)
    }
    
    private static func getRepository<T: ETXGenericDataObject>(defaultRepo: ETXGenericDataObjectRepository<T>, forModelType: T.Type) -> ETXGenericDataObjectRepository<T>{
        let repoClassType = EngaugeTxApplication.getInstance().customDataRepository
        if let repoClassType = repoClassType {
            let customRepository = repoClassType.init(resourcePath: defaultRepo.resourcePath)
            return customRepository as! ETXGenericDataObjectRepository<T> 
        }
        return defaultRepo
    }
    
     static func useCustomDataRepositoryx<M: ETXGenericDataObject, R: CustomizableRepository>(_ repoType: R.Type, forModelType: M.Type) {
        EngaugeTxApplication.addCustomRepository(modelType: forModelType, repositoryType: repoType)
//        EngaugeTxApplication.getInstance().customDataRepository = repoType as! ETXGenericDataObjectRepository<ETXGenericDataObject>.Type
    }
    
    private func getRepository() -> Repository<T> {
//        let s: String = String(describing: self.modelType)
        let s1: String = String(describing: type(of:T.self))
        if let customDefinedRepoType = EngaugeTxApplication.getInstance().customDataRepositories[s1] {
            EngaugeTxLog.debug("A custom repo is defined")
            return customDefinedRepoType.init(resourcePath: self.repository.resourcePath) as! Repository<T>
        }
        return self.repository
    }
    
    /**
     Find a model by it's ID
     - parameter id: The ID of the model
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while finding the item
     */
    override public func findById(_ id: String, completion: @escaping (_ model: T?, _ err: ETXError?) -> Void) {
        super.findById(id) {
            (model, err) in
            self.extractFromResultProperty(model, err, completion)
        }
    }
    
    /**
     Save a model
     - parameter model: The model to be saved
     - parameter completion: Callback when the request completes
     - parameter model: The model, if found.
     - parameter err: If an error occurred while savinga the item
     */
    override public func save(model: T, completion: @escaping (T?, ETXError?) -> Void) {
        if let _ = model.id {
            super.save(model: model) {
                (model, err) in
                self.extractFromResultProperty(model, err, completion)
            }
        } else {
            super.save(model: model, completion: completion)
        }
    }
    
    private func extractFromResultProperty(_ model: T?, _ err: ETXError?, _ completion: @escaping (T?, ETXError?) -> Void) {
        if let model: ETXModel = (model as? ETXModel), let result = model.rawJson?["result"] {
            let m = Mapper<T>().map(JSON: result as! [String : Any])
            completion(m, err)
        } else {
            completion(model, err)
        }
    }
    
    internal static func isValidClassName(_ className: String) -> Bool {
        let pattern = "^[a-z][a-z0-9_]*([a-z0-9_]+)+$"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        // (4):
        let matches = regex.matches(in: className, options: [], range: NSRange(location: 0, length: className.characters.count))
        return (matches.count > 0 )
    }
}

/**
 Indicates that the custom model name specified does not match the format of a Swift class name
 */
public class ETXInvalidModelNameError: Error { }
