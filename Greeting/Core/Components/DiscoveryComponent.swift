//
//  Discovery.swift
//  WSExamplee
//
//  Created by Quoc Cuong on 11/12/19.
//  Copyright © 2019 Quoc Cuong. All rights reserved.
//

import UIKit
import CommonCrypto

public class DiscoveryComponent: Component {
    
    public func componentType() -> ComponentType {
        return .WSDiscovery
    }
    
    public func start() throws {
        debugPrint("DiscoveryComponent Did Start")
    }
    
    public func stop() {
        
    }
    
    var probeMatches : Array<ProbeMatch> = Array<ProbeMatch>()
    
    func getProbeMatches() -> Array<ProbeMatch>{
        return self.probeMatches
    }
    
    public func scanOnvifDevices() {
        let op = SendProbeOperation()
        op.fire()
        
        Engine.shared.getEventComponent()?.listenTo(with: EventName.core.did_receive_onvif_device, event: Event(with: { (data) in
            if let device = data as? ONVIFDevice {
                print(device.hardware)
            }
        }))
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            for device in Engine.shared.getDeviceComponent()!.devices {
//                print(device.hardware)
//            }
//        }
    }
    
    
}

extension Data {
    
    public var sha1: String {
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        self.withUnsafeBytes { bytes in
            _ = CC_SHA1(bytes.baseAddress, CC_LONG(self.count), &digest)
        }
        return Data(digest).base64EncodedString()
        
    }
    
}


extension String {
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
