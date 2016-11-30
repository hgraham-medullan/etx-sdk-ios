//
//  EngaugeTx.swift
//  EngaugeTx
//
//  Created by Sean Hoilett on 11/28/16.
//  Copyright © 2016 Medullan Platform Solutions. All rights reserved.
//

import Foundation


public class TxError {
    
}

public class TxModel {
    
}

protocol Callback {
    func success()
    func error()
}

enum VoidCallback{
    case _success()
    case _error(Int)
}

public enum ObjectCallback {
    case success()
    case error(Int)
}

enum ListCallback {
    case success()
    case error(Int)
}
