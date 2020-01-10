//
//  ParseXMLOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 1/8/20.
//  Copyright © 2020 Tran Cuong. All rights reserved.
//

import Foundation

class ParseProfilesOperation: BaseXMLOperation {
    
    var device: ONVIFDevice?
    
    //PRIVATE
    private var profiles = [Profile]()
    private var profileIndex: Int = -1
    private var currentTag = ""
    private var currentElement = ""
    
    override func processReply(reply: Any?, type: Int, errMsg: String?) {
        if let profiles = reply as? [Profile] {
            for i in 0..<(Engine.shared.getDeviceComponent()?.devices.count ?? 0) {
                if let _device = Engine.shared.getDeviceComponent()?.devices[i] {
                    if _device.xAddr == self.device!.xAddr && _device.hardware == self.device!.hardware {
                        _device.profiles = profiles
                        Engine.shared.getEventComponent()?.trigger(eventName: EventName.http.did_update_device_profiles)
                    }
                }
            }
        } else {
            sendErrorEvent(param: nil)
        }

    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        self.profiles = []
        self.profileIndex = -1
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.currentElement = elementName
        
        if elementName == "trt:Profiles" {
            self.currentTag = "Profiles"
            
            if !attributeDict.isEmpty {
                
                if let token = attributeDict["token"] {
                    let profile = Profile()
                    profile.token = token
                    profile.device = self.device
                    self.profiles.append(profile)
                    self.profileIndex += 1
                }
                
            }
        } else if elementName.contains("VideoSourceConfiguration") {
            self.currentTag = "VideoSourceConfiguration"
            if !attributeDict.isEmpty {
                if let token = attributeDict["token"] {
                    self.profiles[profileIndex].video.token = token
                }
                
            }
            
        } else if elementName.contains("VideoEncoderConfiguration") {
            self.currentTag = "VideoEncoderConfiguration"
            if !attributeDict.isEmpty {
                if let token = attributeDict["token"] {
                    self.profiles[profileIndex].encoder.token = token
                }
                
            }
        } else if elementName.contains("PanTiltLimits") {
            self.currentTag = "PanTiltLimits"
        } else if elementName.contains("ZoomLimits") {
            self.currentTag = "ZoomLimits"
        }
        
        
        if self.currentTag == "VideoSourceConfiguration" {
            if elementName.contains("Bounds") {
                if !attributeDict.isEmpty {
                    self.profiles[profileIndex].video.bounds.x = attributeDict["x"] ?? ""
                    self.profiles[profileIndex].video.bounds.y = attributeDict["y"] ?? ""
                    self.profiles[profileIndex].video.bounds.width = attributeDict["width"] ?? ""
                    self.profiles[profileIndex].video.bounds.height = attributeDict["height"] ?? ""
                }
            }
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "tt:VideoEncoderConfiguration" {
            self.currentTag = ""
        } else if elementName == "tt:PanTiltLimits" {
            self.currentTag = ""
        } else if elementName == "tt:ZoomLimits" {
            self.currentTag = ""
        }
        
        //        print(elementName)
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if self.currentTag == "Profiles" {
            if self.currentElement.contains("Name") {
                self.profiles[profileIndex].name = string
            }
        } else if self.currentTag == "VideoSourceConfiguration" {
            if self.currentElement.contains("Name") {
                self.profiles[profileIndex].video.name = string
            } else if self.currentElement.contains("SourceToken") {
                self.profiles[profileIndex].video.sourceToken = string
            }
        } else if self.currentTag == "VideoEncoderConfiguration" {
            if self.currentElement.contains("Name") {
                self.profiles[profileIndex].encoder.name = string
            } else if self.currentElement.contains("Width") {
                self.profiles[profileIndex].encoder.resolution.width = string
            } else if self.currentElement.contains("Height") {
                self.profiles[profileIndex].encoder.resolution.height = string
            } else if self.currentElement == "tt:Encoding" {
                self.profiles[profileIndex].encoder.encoding = string
            } else if self.currentElement.contains("Quality") {
                self.profiles[profileIndex].encoder.quality = string
            } else if self.currentElement.contains("FrameRateLimit") {
                self.profiles[profileIndex].encoder.framerateLimit = string
            } else if self.currentElement.contains("BitrateLimit") {
                self.profiles[profileIndex].encoder.bitrateLimit = string
            }
            
        } else if self.currentTag == "PanTiltLimits" {
            if self.currentElement.contains("Min") {
                if self.profiles[profileIndex].ptz.panTiltLimits.minX == "" {
                    self.profiles[profileIndex].ptz.panTiltLimits.minX = string
                } else {
                    self.profiles[profileIndex].ptz.panTiltLimits.minY = string
                }
            } else if self.currentElement.contains("Max") {
                if self.profiles[profileIndex].ptz.panTiltLimits.maxX == "" {
                    self.profiles[profileIndex].ptz.panTiltLimits.maxX = string
                } else {
                    self.profiles[profileIndex].ptz.panTiltLimits.maxY = string
                }
            }
        } else if self.currentTag == "ZoomLimits" {
            if self.currentElement.contains("Min") {
                self.self.profiles[profileIndex].ptz.zoomLimits.minX = string
            } else if self.currentElement.contains("Max") {
                self.self.profiles[profileIndex].ptz.zoomLimits.maxX = string
            }
        }
        
        self.currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        processReply(reply: self.profiles, type: 0, errMsg: nil)
    }
    
    
}
