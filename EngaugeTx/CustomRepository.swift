//
//  CustomRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/22/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

public protocol CustomizableRepository: Repo {
    var httpPath: String! { get set}
    func getHttpPath() -> String
    func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void)
    
    func provideInstance<T>(resourcePath: String) -> Repository<T>?
    
}

extension CustomizableRepository {
    public func getHttpPath() -> String {
        return self.httpPath.replacingOccurrences(of: EngaugeTxApplication.baseUrl, with: "")
    }

}

open class ETXCustomRepository<M: ETXModel>: Repository<M>, CustomizableRepository {
    
    required public init(resourcePath: String) {
        super.init(resourcePath: resourcePath)
    }

    public var httpPath: String!
    
    override public func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
    }
    
    public func provideInstance<T>(resourcePath: String) -> Repository<T>? where T : ETXModel {
        return nil
//        return ETXCustomStandaloneFunctionRepository<T>(resourcePath: resourcePath)
    }

}
