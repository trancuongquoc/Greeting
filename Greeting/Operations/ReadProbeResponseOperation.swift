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
    
    override func buildRequest() -> Data? {
        return data
    }
    
    override func processReply(reply: Any?, type: Int, errMsg: String?) {
        print(errMsg)
    }
    
    func parserDidStartDocument(_ parser: XMLParser) {
        print("StartDoc")
    }
    
    override func parserDidEndDocument(_ parser: XMLParser) {
        processReply(reply: nil, type: 0, errMsg: "EndDoc")
    }
}
