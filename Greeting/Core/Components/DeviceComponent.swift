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

    func getProfiles(for device: ONVIFDevice) {
        let fetch = GetProfilesOperation()
        fetch.device = device
        
        let parse = ParseProfilesOperation()
        
        let adapter = BlockOperation {
            parse.data = fetch.replyData
            parse.device = fetch.device
        }
        
        adapter.addDependency(fetch)
        parse.addDependency(adapter)
        
        Engine.shared.getOperationComponent()?.enqueue(operation: fetch)
        Engine.shared.getOperationComponent()?.operationQueue.addOperation(adapter)
        Engine.shared.getOperationComponent()?.enqueue(operation: parse)
    }
    
    
}
