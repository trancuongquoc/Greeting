//
//  Profile.swift
//  WS-Discovery iOS
//
//  Created by Tran Cuong on 11/26/19.
//  Copyright © 2019 Quoc Cuong. All rights reserved.
//

import UIKit

public class Profile {
    
    public var device: ONVIFDevice?
    public var token: String = ""
    public var name: String = ""
    public var video = VideoSourceConfiguration()
    public var encoder = VideoEncoderConfiguration()
    public var ptz = PTZ()
    public var stream = StreamUri()
    public var snapshot = SnapshotUri()
    
//    public func getPresets() {
//        let op = GetPresetsOperation()
//        op.device = self.device
//        op.profileToken = self.token
//        op.fire()
//    }
//    
//    public func getStreamUri() {
//        let op = GetStreamOperation()
//        op.device = self.device
//        op.profileToken = self.token
//        op.delegate = self
//        op.fire()
//    }
//    
//    public func getSnapshotUri() {
//        let op = GetSnapshotOperation()
//        op.device = self.device
//        op.profileToken = self.token
//        op.delegate = self
//        op.fire()
//    }
}

//extension Profile: GetStreamDelegate {
//    public func getStreamDidFinish(with streamUri: StreamUri?, success: Bool, description: String) {
//        if success {
//            if streamUri != nil {
//                self.stream = streamUri!
//            }
//        } else {
//            print(description)
//        }
//    }
//}
//
//extension Profile: GetSnapshotDelegate {
//    public func getSnapshotDidFinish(with snapshotUri: SnapshotUri?, success: Bool, description: String) {
//        if success {
//            if snapshotUri != nil {
//                self.snapshot = snapshotUri!
//            }
//        } else {
//            print(description)
//        }
//    }
//    
//}
