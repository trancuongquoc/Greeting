//
//  GetSystemDateAndTimeOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 1/7/20.
//  Copyright © 2020 Tran Cuong. All rights reserved.
//

import Foundation

class GetSystemDateAndTimeOperation: ONVIFServiceOperation {
    override func buildRequest() -> Data? {
        let soap =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"
        xmlns:tds="http://www.onvif.org/ver10/device/wsdl">
        <SOAP-ENV:Body>
        <tds:GetSystemDateAndTime/>
        </SOAP-ENV:Body>
        </SOAP-ENV:Envelope>
        """
        let data = soap.data(using: .utf8)
        return data
    }
    
    override func processReply(reply: Any?, errMsg: String?, error: HttpError?) {
        print(reply)
    }
}
