//
//  Condtion.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 1/11/17.
//  Copyright © 2017 Medullan Platform Solutions. All rights reserved.
//

import Foundation

protocol Condition {
    func toString() -> String
    func toJson() -> [String:Any]
}
