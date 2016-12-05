//
//  TxModel.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 12/1/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation

public class ETXModel:PropertyNames {
    var id: String = ""
}

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames
{
    func propertyNames() -> [String] {
        return Mirror(reflecting: self).children.flatMap { $0.label }
    }
}
