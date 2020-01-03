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

}

