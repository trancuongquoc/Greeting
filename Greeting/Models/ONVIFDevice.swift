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

public class ONVIFDevice: NSObject, XMLParserDelegate {
    
    var username = ""
    var password = ""
    
    public var hardware: String = ""
    public var xAddr: String = ""
    public var profiles = [Profile]()
    
//    public func relativeMove(profileToken: String, panAddition: CGFloat, tiltAddition: CGFloat, zoomAddition: CGFloat) {
//        let op = RelativeMoveOperation()
//        op.device = self
//        op.profileToken = profileToken
//
//        let vector = PTZVector(pan: panAddition, tilt: tiltAddition, zoom: zoomAddition)
//        op.ptzVector = vector
//        op.fire()
//    }
//
//    public func getNodes() {
//        let op = GetNodesOperation()
//        op.device = self
//        op.fire()
//    }
//    public func getProfiles() {
//        let op = GetProfilesOperation()
//        op.device = self
//        op.delegate = self
//        op.fire()
//    }
//
//    public func getSystemDateAndTime() {
//        let op = GetSystemDateAndTimeOperation()
//        op.device = self
//        op.fire()
//    }
    
    public func set(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
}

//extension Device: GetProfilesDelegate {
//    public func getProfilesDidFinish(with profiles: [Profile], success: Bool, description: String) {
//        if success {
//            self.profiles = profiles
//        } else {
//            print(description)
//        }
//    }
//}


