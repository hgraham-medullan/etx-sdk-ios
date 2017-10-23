//
//  CustomRepository.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 10/22/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation
import Siesta

protocol CustomizableRepository {
    var httpPath: String! { get set}
    func getHttpPath() -> String
    func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void)
}

extension CustomizableRepository {
    public func getHttpPath() -> String {
        return self.httpPath.replacingOccurrences(of: EngaugeTxApplication.baseUrl, with: "")
    }

}

open class ETXCustomRepository<M: ETXModel>: Repository<M>, CustomizableRepository {
    var httpPath: String!
    
    override public func beforeResourceRequest(_ resource: Resource, completion: @escaping () -> Void) {
        self.httpPath = resource.url.absoluteString
    }

}
