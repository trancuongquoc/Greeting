//
//  ReadResponseOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

class ReadProbeResponseOperation: BaseXMLOperation {
    
    public var data: Data?
    
    private var currentElement = ""
    private var messageID: String = ""
    private var relatedTo: String = ""
    private var urn: String = ""
    private var hardware: String = ""
    private var xAddr: String = ""
    private var isProbeMatch = false
    
    override func buildRequest() -> Data? {
        return data
    }
    
    override func processReply(reply: Any?, type: Int, errMsg: String?) {
        if type == 0 {
            if let probeMatch = reply as? ProbeMatch {
                
                if !Engine.shared.getDiscoveryComponent()!.probeMatches.contains(where: { (pm) -> Bool in
                    pm.messageID == probeMatch.messageID
                }) {
                    Engine.shared.getDiscoveryComponent()?.probeMatches.append(probeMatch)
                    Engine.shared.getEventComponent()?.trigger(eventName: EventName.udp.udp_did_receive_probematch, information: probeMatch)
                }
                
            }
            
        } else {
            sendErrorEvent(param: errMsg)
        }
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName.contains("ProbeMatch") {
            self.isProbeMatch = true
        }
        
        if elementName.contains("MessageID") {
            //            print(elementName)
            currentElement = elementName
        } else if elementName.contains("RelatesTo"){
            currentElement = elementName
        } else if elementName.contains("Address") {
            currentElement = elementName
            //            print(elementName)
        } else if elementName.contains("Scopes") {
            currentElement = elementName
            //            print(elementName)
        } else if elementName.contains("XAddr") {
            currentElement = elementName
            //            print(elementName)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard !string.isEmpty else {
            return
        }
        
        if self.currentElement.contains("MessageID") {
            //                print(currentElement, " : ", data)
            let stringID = string.split(separator: ":")
            if stringID.last != nil {
                let uuid = stringID.last ?? ""
                self.messageID = String(uuid)
            }
            
            
        } else if self.currentElement.contains("RelatesTo") {
            //                print(currentElement, " : ", data)
            let stringID = string.split(separator: ":")
            if stringID.last != nil {
                let uuid = stringID.last ?? ""
                self.relatedTo = String(uuid)
            }
            
        } else if self.currentElement.contains("Address") {
            //                print(currentElement, " : ", data)
            let stringID = string.split(separator: ":")
            if stringID.last != nil {
                let uuid = stringID.last ?? ""
                self.urn = String(uuid)
            }
            
            
            //            print(elementName)
        } else if self.currentElement.contains("Scopes") {
            //                print(currentElement, " : ", data)
            let scopes = string.split(separator: " ")
            
            if !scopes.isEmpty {
                for scope in scopes {
                    if scope.contains("hardware") {
                        let hardware = scope.split(separator: "/").last ?? ""
                        self.hardware = String(hardware)
                    }
                }
            }
            //            print(elementName)
        } else if self.currentElement.contains("XAddr") {
            //print(currentElement, " : ", data)
            let stringID = string.split(separator: " ")
            if stringID.first != nil {
                let XAddr = stringID.first ?? ""
                self.xAddr = String(XAddr)
            }
        }
        self.currentElement = ""
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        if !self.isProbeMatch {
            self.processReply(reply: nil, type: 1, errMsg: "Not a Probe Match.")
        } else {
            let probeMatch = ProbeMatch()
            probeMatch.hardware = self.hardware
            probeMatch.messageID = self.messageID
            probeMatch.relatedTo = self.relatedTo
            probeMatch.urn = self.urn
            probeMatch.xAddr = self.xAddr
            
            self.processReply(reply: probeMatch, type: 0, errMsg: nil)
        }
    }
}
