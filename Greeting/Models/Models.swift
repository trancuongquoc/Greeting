//
//  Profile.swift
//  WS-Discovery iOS
//
//  Created by Tran Cuong on 11/23/19.
//  Copyright © 2019 Quoc Cuong. All rights reserved.
//

import UIKit

public class PTZVector {
    public var panTilt: Vector2D?
    public var zoom: Vector1D?
    
    public init(pan: CGFloat, tilt: CGFloat, zoom: CGFloat) {
        self.panTilt = Vector2D(x: pan, y: tilt)
        self.zoom = Vector1D(x: zoom)
    }
}

public class Vector2D {
    public var x: CGFloat? //Pan
    public var y: CGFloat? //Tilt
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}

public class Vector1D {
    public var x: CGFloat?
    
    public init(x: CGFloat) {
        self.x = x
    }
}

public class StreamUri {
    public var mediaUri = MediaUri()
}

public class SnapshotUri {
    public var mediaUri = MediaUri()
}
public class MediaUri {
    public var uri: String = ""
    public var invalidAfterConnect: Bool!
    public var invalidAfterReboot: Bool!
    public var timeout = ""
}

public class PTZ {
    public var panTiltLimits = PanTiltLimits()
    public var zoomLimits = ZoomLimits()
}

public class ZoomLimits {
    public var minX = ""
    public var maxX = ""
}

public class PanTiltLimits {
    public var minX = ""
    public var maxX = ""
    public var minY = ""
    public var maxY = ""
}

public class VideoSourceConfiguration {
    public var token: String = ""
    public var name: String = ""
    public var sourceToken: String = ""
    public var bounds = Bounds()
}

public class VideoEncoderConfiguration {
    public var token: String = ""
    public var name: String = ""
    public var resolution = Resolution()
    public var quality = ""
    public var framerateLimit = ""
    public var bitrateLimit = ""
    public var encoding = ""
}

public class Resolution {
    public var width: String = ""
    public var height: String = ""
}

public class Bounds {
    public var x: String = ""
    public var y: String = ""
    public var width: String = ""
    public var height: String = ""
}
