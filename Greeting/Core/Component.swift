//
//  Component.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/27/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

@objc public enum ComponentType : Int {
    case View
    case Event
    case WSDiscovery
    case Operations
    case UDP
}

@objc public protocol Component {
    func componentType() -> ComponentType
    func start() throws
    func stop()
    @objc optional func priority() -> NSNumber? /// DEFAULT 1000
}
