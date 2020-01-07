//
//  DeviceComponent.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/31/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

public class DeviceComponent: Component {
    public func componentType() -> ComponentType {
        return .ONVIFDevice
    }
    
    public func start() throws {
        debugPrint("DeviceComponent Did Start")
    }
    
    public func stop() {
        debugPrint("DeviceComponent Did Stop")
    }
    
    var devices : Array<ONVIFDevice> = Array<ONVIFDevice>()
    
    func getONVIFDevices() -> Array<ONVIFDevice>{
        return self.devices
    }

    func getTime() {
        let op = GetSystemDateAndTimeOperation()
        op.device = devices.first
        op.fire()
    }
    
}
