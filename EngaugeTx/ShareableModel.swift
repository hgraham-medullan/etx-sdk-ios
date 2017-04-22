//
//  ShareableModel.swift
//  EngaugeTx
//
//  Created by Layton Whiteley on 4/19/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//


import Foundation
import ObjectMapper

open class ETXShareableModel: ETXPersistedModel, ETXShareable {
    
    internal class var modelResourcePath: String? {
        return  nil
    }
    
    
    public override init() {
        super.init()
    }
    
    required public init?(map: Map) {
        super.init(map: map)
    }
    
    open override func mapping(map: Map) {
        super.mapping(map: map)
    }
}

protocol ETXShareable {
    static var modelResourcePath: String? { get }
}

extension ETXShareable where Self: ETXShareableModel {
    internal static var resourcePath: String {
        var _modelResourcePath: String = String(describing: self)
        if self.modelResourcePath != nil {
            _modelResourcePath = self.modelResourcePath!
        }
        
        return _modelResourcePath
    }
}

