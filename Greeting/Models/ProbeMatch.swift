//
//  ProbeMatch.swift
//  WS-Discovery iOS
//
//  Created by Tran Cuong on 11/22/19.
//  Copyright © 2019 Quoc Cuong. All rights reserved.
//

import Foundation

public class ProbeMatch: NSObject, XMLParserDelegate {
    
    private var currentElement = ""
    
    var messageID: String = ""
    var relatedTo: String = ""
    var urn: String = ""
    var hardware: String = ""
    var xAddr: String = ""
    var isProbeMatch = false
    
    init(data: Data) {
        super.init()
        parse(data)
    }
    
    public func parse(_ data: Data) {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

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
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {

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
}
