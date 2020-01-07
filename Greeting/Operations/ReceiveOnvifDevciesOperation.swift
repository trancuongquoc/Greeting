//
//  ReceiveOnvifDeviceOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

class ReceiveOnvifDeviceOperation: UDPOperation {
    override func requestType() -> String {
        return PROBE_MATCH
    }

    override func onReplyRequest(requestType: String ,replyType: Int, replyData: Any?) {
        if replyType == 0 {
            if let probeMatch = replyData as? ProbeMatch {
                let device = ONVIFDevice()
                device.hardware = probeMatch.hardware
                device.xAddr = probeMatch.xAddr
                
                if !Engine.shared.getDeviceComponent()!.devices.contains(where: { (onvifDevice) -> Bool in
                    onvifDevice.xAddr == device.xAddr
                }) {
                    
                    Engine.shared.getDeviceComponent()?.devices.append(device)
                }
                
                Engine.shared.getEventComponent()?.trigger(eventName: EventName.udp.udp_did_recognize_onvif_device, information: device)
            }
        } else {
            
        }
    }
}
