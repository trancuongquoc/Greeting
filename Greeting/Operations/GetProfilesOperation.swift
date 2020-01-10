//
//  GetProfilesOperation.swift
//  Greeting
//
//  Created by Quoc Cuong on 1/8/20.
//  Copyright © 2020 Tran Cuong. All rights reserved.
//

import Foundation

class GetProfilesOperation: OnvifHTTPOperation {
    
    override func buildRequest() -> Data? {
        let nonce = generateNonce()
        let date = generateDateString()
        
        let digest = generatePasswordDigest(from: self.device?.password ?? "", with: nonce, and: date)
        
        guard digest != "" else {
            return nil
        }
        
        let soap = """
        <?xml version="1.0" encoding="UTF-8"?>
        <s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope"
        xmlns:trt="http://www.onvif.org/ver10/media/wsdl"
        xmlns:tt="http://www.onvif.org/ver10/schema">
        <s:Header>
        <Security xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" s:mustUnderstand="1">
        <UsernameToken>
        <Username>\(self.device?.username ?? "admin")</Username>
        <Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordDigest">\(digest)</Password>
        <Nonce EncodingType="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-soap-message-security-1.0#Base64Binary">\(nonce)</Nonce>
        <Created xmlns="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">\(date)</Created>
        </UsernameToken>
        </Security>
        </s:Header>
        <s:Body>
        <trt:GetProfiles/>
        </s:Body>
        </s:Envelope>
        """
        
//        print(soap)
        let data = soap.data(using: .utf8)
        return data
    }
    
    override func processReply(reply: Any?, errMsg: String?, error: HttpError?) {
//        let data = reply as? Data
//        let str = String(data: data!, encoding: .utf8)
//        print(str)
        sendSuccessEvent(param: reply)
    }
}
