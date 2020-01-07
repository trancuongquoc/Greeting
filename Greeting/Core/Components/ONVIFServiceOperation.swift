//
//  ONVIFServiceOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 1/7/20.
//  Copyright © 2020 Tran Cuong. All rights reserved.
//

import Foundation

class ONVIFServiceOperation: HTTPCoreOperation {
    var device: ONVIFDevice?
    
    override func httpParserOnSuccess() -> ContentParser {
        return .TEXT
    }
    
    override func requestURL() -> String {
        return device?.xAddr ?? ""
    }

}
