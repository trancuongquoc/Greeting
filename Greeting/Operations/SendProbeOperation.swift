//
//  SendProbeOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/30/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import Foundation

class SendProbeOperation: UDPOperation {
    
    var multicastAddress = "239.255.255.250"
    var filterType = ""
    
    func messageID() -> String {
        return UUID.init().uuidString
    }
    
    override func numberRequestType() -> Int32 {
        return 1
    }
    
    override func endpointAddress() -> String? {
        return multicastAddress
    }
    
    func buildProbeMessage() -> Data? {
        if filterType != "" {
            let probe = """
            <?xml version="1.0" encoding="UTF-8"?>
            <e:Envelope xmlns:e="http://www.w3.org/2003/05/soap-envelope"
            xmlns:w="http://schemas.xmlsoap.org/ws/2004/08/addressing"
            xmlns:d="http://schemas.xmlsoap.org/ws/2005/04/discovery"
            xmlns:dn="http://www.onvif.org/ver10/network/wsdl">
            <e:Header>
            <w:MessageID>uuid:\(messageID())</w:MessageID>
            <w:To e:mustUnderstand="true">urn:schemas-xmlsoap-org:ws:2005:04:discovery</w:To>
            <w:Action
            a:mustUnderstand="true">http://schemas.xmlsoap.org/ws/2005/04/discovery/Pr
            obe</w:Action>
            </e:Header>
            <e:Body>
            <d:Probe>
            <d:Types>dn:\(filterType)</d:Types>
            </d:Probe>
            </e:Body>
            </e:Envelope>
            """
            
            let data = probe.data(using: .utf8)
            return data
        }
        
        let probe = """
        <?xml version="1.0" encoding="UTF-8"?>
        <e:Envelope xmlns:e="http://www.w3.org/2003/05/soap-envelope"
        xmlns:w="http://schemas.xmlsoap.org/ws/2004/08/addressing"
        xmlns:d="http://schemas.xmlsoap.org/ws/2005/04/discovery"
        xmlns:dn="http://www.onvif.org/ver10/network/wsdl">
        <e:Header>
        <w:MessageID>uuid:\(messageID())</w:MessageID>
        <w:To e:mustUnderstand="true">urn:schemas-xmlsoap-org:ws:2005:04:discovery</w:To>
        <w:Action
        a:mustUnderstand="true">http://schemas.xmlsoap.org/ws/2005/04/discovery/Pr
        obe</w:Action>
        </e:Header>
        <e:Body>
        <d:Probe>
        </d:Probe>
        </e:Body>
        </e:Envelope>
        """
        
        let data = probe.data(using: .utf8)
        return data
    }
    
    override func buildRequest() -> Data? {
        self.buildProbeMessage()
    }
    
    override func onReplyRequest(code: Int32, type: Int, replyData: Any?) {
        debugPrint("SendProbeOperation")
        if type == 0 {
            sendSuccessEvent(param: nil)
        } else {
            sendErrorEvent(param: nil)
        }
    }
}
