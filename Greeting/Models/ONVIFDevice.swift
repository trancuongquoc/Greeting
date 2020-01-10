//
//  Device.swift
//  WS-Discovery iOS
//
//  Created by Quoc Cuong on 11/18/19.
//  Copyright © 2019 Quoc Cuong. All rights reserved.
//

import UIKit

public enum ONVIFDeviceService {
    case ProbeMatch
    case GetSystemDateAndTime
    case GetDeviceInformation
    case GetCapabilities
    case SetHostname
    case GetStream
    case GetProfiles
    case GetSnapshot
}

public class ONVIFDevice {
    
    var username = ""
    var password = ""
    
    public var hardware: String = ""
    public var xAddr: String = ""
    public var profiles = [Profile]()
    
    public func set(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    public func set(username: String) {
        self.username = username
    }
    
    public func set(password: String) {
        self.password = password
    }
    
}



